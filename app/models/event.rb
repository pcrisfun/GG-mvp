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
  has_many :state_stamps
  has_one :host_album, :class_name => 'Album', :dependent => :destroy

  attr_accessible :title, :topic, :host_firstname, :host_lastname, :host_business,
                  :bio, :twitter, :facebook, :website, :webshop, :permission,
                  :payment_options, :paypal_email, :sendcheck_address, :sendcheck_address2,
                  :sendcheck_city, :sendcheck_state, :sendcheck_zip, :kind, :description,
                  :begins_at, :begins_at_time, :ends_at, :ends_at_time, :datetime_tba, :availability,
                  :skill_list, :tool_list, :requirement_list, :other_needs, :hours, :hours_per,
                  :location_address, :location_address2, :location_city, :location_state, :location_zipcode,
                  :location_private, :location_nbrhood, :location_varies, :age_min, :age_max,
                  :registration_min, :registration_max, :price, :respect_my_style, :gender, :reject_reason, :revoke_reason,
                  :state, :legal_name, :user_id

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
        :amount => 3000, # amount in cents, again
        :currency => "usd",
        :card => stripe_card_token,
        :description => "Apprenticeship payment from #{self.user.email}"
      )
      logger.debug(charge)
      update_attribute(:charge_id, charge.id)
      logger.info "Processed payment #{charge.id}"
    end
  rescue Stripe::CardError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, e.message
    false
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def tba_is_blank
    datetime_tba.blank?
  end

  def should_validate_begins_at?
    :tba_is_blank && (self.started? || self.pending?)
  end

  def residential
    location_private == true
  end

  def age_min_is_set
    age_min.present?
  end

  def reg_min_is_set
    registration_min.present?
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

  def make_stamp
    self.state_stamps.create(state: self.state, stamp: Date.today)
  end

  def countdown_message

  end

  state_machine :state, :initial => :started do
    after_transition any => any do |event|
      event.make_stamp
    end

    # after_transition :to => :accepted do |event, transition|
    #   event.notify_preregs
    # end

    state :started do
    end

    state :pending do
    end

    state :accepted do
    end

    state :canceled do
    end

    state :filled do
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

    event :submit do
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

    event :complete do
      transition :all => :completed
    end

    event :reopen do
      transition :filled => :accepted
    end

  end

  # def notify_preregs
  #   users = Set.new
  #   self.user.events.each do |event|
  #     event.preregs.each do |prereg|
  #       users << prereg.user
  #     end
  #   end

  #   if users.any?
  #     prereg_user_html = "<ul>" + users.map do |prereg_user|
  #        "<li>#{prereg_user.name} (#{prereg_user.email})</li>"
  #     end.join + "</ul>"

  #     return false unless valid?
  #     Pony.mail({
  #       :to => "GG Admins<hello@girlsguild.com>",
  #       :from => "Diana & Cheyenne<hello@girlsguild.com>",
  #       :reply_to => "GirlsGuild<hello@girlsguild.com>",
  #       :subject => "Send a prereg email - #{self.topic} with #{user.name}",
  #       :html_body => %(<p>Send to this list:</p>
  #         <p>#{prereg_user_html}</p>
  #         <p>Here's something to copy/paste</p>
  #         <h1>Psst, #{prereg_user.first_name}!</h1>
  #         <p>We wanted you to be the first to know that a maker you're following, #{user.name}, has posted a new #{self.type}. Check it out!</p>
  #         <p>We'll be announcing it to the GirlsGuild community soon, so now's your chance to get first dibs on signing up.</p>
  #         <p>Thanks, and Happy Making!</p>
  #         <p>The GirlsGuild Team</p>),
  #     })
  #     return true
  #   end
  # end

  def verify_delete?
    self.started?
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
    if value == ""
      value = nil
    end
    self.send("#{attribute}=", value)
    if validations?(self, attribute.to_sym)
      if self.group_valid?(attribute.to_sym) && self.update_attribute(attribute, value)
        if ['topic', 'host_firstname', 'host_lastname'].include?(attribute)
          self.generate_title
        end
        #if self.accepted? && required?(self, attribute.to_sym)
          #self.resubmit
          #self.deliver_resubmit
        #end
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

  def nice_dates_apprenticeships(format = '%a, %b %d')
    if self.datetime_tba
      return "TBA"
    elsif self.begins_at && self.ends_at
      return "#{self.begins_at.strftime(format)} - #{self.ends_at.strftime(format)}"
    else
      return ""
    end
  end
  def nice_dates_workshops(format = '%a, %b %d')
    if self.datetime_tba
      return "TBA"
    elsif self.begins_at && self.begins_at_time && self.ends_at_time
      return "#{self.begins_at.strftime(format)}, #{self.begins_at_time.strftime('%I:%M%P') } - #{self.ends_at_time.strftime('%I:%M%P')}"
    else
      return ""
    end
  end

  def state_label_class
    labels = { started: "label-info btn-block",
               pending: "label-warning btn-block",
               accepted: "label-success btn-block",
               confirmed: "label-success btn-block",
               canceled: "label-important btn-block",
               filled: "label-success btn-block",
               in_progress: "label-success btn-block",
               completed: "label-inverse btn-block"
             }
    return labels[self.state.to_sym]
  end

  def submitted_signups
    return self.signups.where(:state => ["pending", "accepted", "confirmed", "completed", "declined"])
  end

  def confirmed_signups
    return self.signups.where(:state => "confirmed")
  end

  def declined_signups
    return self.signups.where(:state => "declined")
  end

  def submitted_preregs
    return self.preregs
  end

  def spots_left
    if self.filled?
      return "Full"
    elsif self.completed?
      return "Past"
    elsif self.registration_max
      return "#{self.registration_max - self.signups.where(:state => ["confirmed"]).count} spots left"
    else
      return ''
    end
  end

end

