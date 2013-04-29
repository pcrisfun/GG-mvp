class Event < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor


  belongs_to :user

  has_many :signups, :dependent => :destroy
  has_many :preregs

  has_one :host_album, :class_name => 'Album', :dependent => :destroy

  validation_group :save do
    validates_presence_of :topic, :message => ' must be included in order to save your form.'
    validates_presence_of :host_firstname, :message => ' must be included in order to save your form.'
    validates_presence_of :host_lastname, :message => ' must be included in order to save your form.'
  end

  #validates_presence_of :bio, :website, :permission, :description, :begins_at, :skill_list, :tool_list, :location_address, :location_city, :location_state, :location_zipcode, :age_min, :age_max, :registration_max
  #validates_numericality_of :age_min, :greater_than => 0
  #validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set."
  #validates_numericality_of :registration_max, :greater_than_or_equal_to => 1, :message => " registrations must be greater than 0."

  attr_accessible :title, :topic, :host_firstname, :host_lastname, :host_business,
                  :bio, :twitter, :facebook, :website, :webshop, :permission,
                  :payment_options, :paypal_email, :sendcheck_address, :sendcheck_address2,
                  :sendcheck_city, :sendcheck_state, :sendcheck_zip, :kind, :description,
                  :begins_at, :begins_at_time, :ends_at, :ends_at_time, :datetime_tba,
                  :skill_list, :tool_list, :requirement_list, :other_needs, :hours, :hours_per,
                  :location_address, :location_address2, :location_city, :location_state, :location_zipcode,
                  :location_private, :location_nbrhood, :location_varies, :age_min, :age_max,
                  :registration_min, :registration_max, :price, :respect_my_style, :facilitate, :gender

  after_create
  def generate_title
    self.title = "#{self.topic} with #{self.host_firstname} #{self.host_lastname}"
    self.save
  end

  def title_html
    "<span class='title-topic'>#{self.topic}</span> <span class='with'>with</span><span class='title-name'> #{self.host_firstname} #{self.host_lastname}</span>".html_safe
  end

  attr_accessible :stripe_card_token
  attr_accessor :stripe_card_token

  acts_as_taggable
  acts_as_taggable_on :skills, :tools, :requirements

  before_save :fix_tags
  def fix_tags
    # OPTIMIZE: lol this is a hack to fix acts as taggable on
    self.skill_list = self.skill_list.map { |t| t.strip.gsub(/[^,A-Z0-9 '-]/i, '') }.join(',')
    self.tool_list = self.tool_list.map { |t| t.strip.gsub(/[^,A-Z0-9 '-]/i, '') }.join(',')
    self.requirement_list = self.requirement_list.map { |t| t.strip.gsub(/[^,A-Z0-9 '-]/i, '') }.join(',')
  end

  def begins_at=(new_date)
     write_attribute(:begins_at, Chronic::parse(new_date).strftime('%Y-%m-%d %H:%M:%S'))
  end

  def ends_at=(new_date)
     write_attribute(:ends_at, Chronic::parse(new_date).strftime("%Y-%m-%d %H:%M:%S"))
  end

  def process_payment
    logger.info "Processing payment"
    unless charge_id.present?
      charge = Stripe::Charge.create(
        :amount => 900, # amount in cents, again
        :currency => "usd",
        :card => stripe_card_token,
        :description => "Apprenticeship payment from #{self.user.email}"
      )
      update_attribute(:charge_id, charge.id)
      logger.info "Processed payment #{charge.id}"
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def tba_is_blank
    datetime_tba.blank?
  end

  def google_address
    if self.location_private && self.location_nbrhood
      return "#{self.location_nbrhood} #{self.location_city} #{self.location_state} #{self.location_zipcode}"
    elsif !self.location_private && self.location_address && self.location_zipcode
      return "#{self.location_address} #{self.location_city} #{self.location_state} #{self.location_zipcode}"
    else
      return "Austin, TX"
    end
  end


  state_machine :state, :initial => :started do

    state :started do
      Rails.logger.info("STATE: started")
    end

     state :private do
      Rails.logger.info("STATE: private")
      validates_presence_of :bio, :website, :description, :begins_at, :skill_list, :tool_list, :location_address, :location_city, :location_state, :location_zipcode, :age_min, :age_max, :registration_max
      validates_numericality_of :age_min, :greater_than => 0
      validates_numericality_of :age_max, :greater_than => :age_min, :message => "must be greater than the minimum age you set."
      validates_numericality_of :registration_max, :greater_than_or_equal_to => 0
      validate :host_album_limit
     end

    state :payment do
      Rails.logger.info("STATE: payment")
      validates_presence_of :permission
    end

    state :pending do
    end

    state :accepted do
    end

    state :canceled do
    end

    state :filled do
    end

    state :in_progress do
    end

    state :completed do
    end

    event :reject do
      transition :pending => :started
    end

    event :revoke do
      transition :accepted => :started
    end

    event :designed do
      transition :started => :private
    end

    event :private_complete do
        transition :private => :payment
    end

    event :paid do
      transition :payment => :pending
    end

    event :edit_design do
      transition [:payment, :private] => :started
    end

    event :edit_private do
      transition :payment => :private
    end

    event :accept do
      transition :pending => :accepted
    end

    event :resubmit do
      transition all => :pending
    end

    event :cancel do
      transition all => :canceled
    end

    event :fill do
      transition :accepted => :filled
    end

  end

  after_create :create_host_album
  def create_host_album
    self.host_album  = Album.new(title: "Images for #{self.title}", limit: 5)
  end

  def min_capacity_met?
    self.signups.where(:state => "confirmed").count >= self.registration_min
  end

  def max_capacity_met?
    self.signups.where(:state => "confirmed").count >= self.registration_max
  end

  def host_album_limit
    if self.host_album.limit && ( self.host_album.photos.size < self.host_album.limit )
      errors.add(:images, "please include exactly 5 images.")
    end
  end

end

