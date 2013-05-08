class Event < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor
  include ApplicationHelper


  belongs_to :user

  has_many :signups, :dependent => :destroy
  has_many :preregs

  has_one :host_album, :class_name => 'Album', :dependent => :destroy

  validation_group :design do
    validates_presence_of :topic
    validates_presence_of :host_firstname
    validates_presence_of :host_lastname
    validates_presence_of :kind
    validates_presence_of :description
    validates_presence_of :bio
    validates_presence_of :website
    validates_presence_of :begins_at
    validates_presence_of :skill_list
    validates_presence_of :tool_list
    validates_presence_of :location_address
    validates_presence_of :location_city
    validates_presence_of :location_state
    validates_presence_of :location_zipcode
    validates_presence_of :age_min
    validates_presence_of :age_max
    validates_presence_of :registration_max
    validates_numericality_of :age_min, :greater_than => 0
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set."
    validates_numericality_of :registration_max, :greater_than_or_equal_to => 1, :message => " registrations must be greater than 0."
    validate :host_album_limit
  end

  validation_group :private do
    validates_presence_of :permission
  end
  validation_group :topic do
    validates_presence_of :topic
  end
  validation_group :host_firstname do
    validates_presence_of :host_firstname
  end
  validation_group :host_lastname do
    validates_presence_of :host_lastname
  end
  validation_group :kind do
    validates_presence_of :kind
  end
  validation_group :description do
    validates_presence_of :description
  end
  validation_group :bio do
    validates_presence_of :bio
  end
  validation_group :website do
    validates_presence_of :website
  end
  validation_group :begins_at do
    validates_presence_of :begins_at
  end
  validation_group :skill_list do
    validates_presence_of :skill_list
  end
  validation_group :tool_list do
    validates_presence_of :tool_list
  end
  validation_group :location_address do
    validates_presence_of :location_address
  end
  validation_group :location_city do
    validates_presence_of :location_city
  end
  validation_group :location_state do
    validates_presence_of :location_state
  end
  validation_group :location_zipcode do
    validates_presence_of :location_zipcode
  end
  validation_group :age_min do
    validates_presence_of :age_min
    validates_numericality_of :age_min, :greater_than => 0
  end
  validation_group :age_max do
    validates_presence_of :age_max
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set."
  end
  validation_group :registration_max do
    validates_presence_of :registration_max
    validates_numericality_of :registration_max, :greater_than_or_equal_to => 1, :message => " registrations must be greater than 0."
  end

  attr_accessible :title, :topic, :host_firstname, :host_lastname, :host_business,
                  :bio, :twitter, :facebook, :website, :webshop, :permission,
                  :payment_options, :paypal_email, :sendcheck_address, :sendcheck_address2,
                  :sendcheck_city, :sendcheck_state, :sendcheck_zip, :kind, :description,
                  :begins_at, :begins_at_time, :ends_at, :ends_at_time, :datetime_tba,
                  :skill_list, :tool_list, :requirement_list, :other_needs, :hours, :hours_per,
                  :location_address, :location_address2, :location_city, :location_state, :location_zipcode,
                  :location_private, :location_nbrhood, :location_varies, :age_min, :age_max,
                  :registration_min, :registration_max, :price, :respect_my_style, :facilitate, :gender

  def generate_title
    self.title = "#{self.topic} with #{self.host_firstname} #{self.host_lastname}"
    self.save(validate: false)
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

    event :restart do
      transition all => :started
    end

    event :revoke do
      transition :accepted => :started
    end

    event :paid do
      transition :started => :pending
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
    if self.host_album && self.host_album.limit && ( self.host_album.photos.size != self.host_album.limit )
      errors.add(:images, "please include exactly #{self.host_album.limit} images.")
    end
  end

  def xeditable_update(attribute, value)
    if self.pending?
      return false
    end
    if value == ""
      value = nil
    end
    self.send("#{attribute}=", value)
    if validations?(self, attribute.to_sym)
      if self.group_valid?(attribute.to_sym) && self.update_attribute(attribute, value)
        if ['topic', 'host_firstname', 'host_lastname'].include?(attribute)
          self.generate_title
        end
        if !self.started? && required?(self, attribute.to_sym)
          self.resubmit
          self.deliver_resubmit
        end
        return true
      else
        return false
      end
    elsif self.update_attribute(attribute, value)
      if ['topic', 'host_firstname', 'host_lastname'].include?(attribute)
        self.generate_title
      end
      return true
    else
      return false
    end
    return false
  end

  def nice_dates(format = '%a, %b %d')
    if self.datetime_tba
      return 'TBA'
    elsif self.begins_at && self.ends_at
      return "#{self.begins_at.strftime(format)} to #{self.ends_at.strftime(format)}"
    else
      return ""
    end
  end

  def state_label_class
    labels = { started: "label-info",
               pending: "label-warning",
               accepted: "label-success",
               canceled: "label-important",
               filled: "label-success",
               in_progress: "label-success",
               completed: "label-inverse"
             }
    return labels[self.state.to_sym]
  end

  def spots_left
    if self.filled?
      return "Full"
    else
      return "#{self.registration_max - self.signups.where(:state => "confirmed").count}"
    end
  end

end

