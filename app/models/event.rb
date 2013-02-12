class Event < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor

  belongs_to :user
  validates_presence_of :topic, :message => ' must be included in order to save your form.'
  validates_presence_of :host_firstname, :message => ' must be included in order to save your form.'
  validates_presence_of :host_lastname, :message => ' must be included in order to save your form.'

  attr_accessible :title, :topic, :host_firstname, :host_lastname, :host_business, :bio, :twitter, :facebook, :website, :webshop, :permission, :payment_options, :paypal_email, :sendcheck_address, :sendcheck_address2, :sendcheck_city, :sendcheck_state, :sendcheck_zip, :kind, :description, :begins_at, :begins_at_time, :ends_at, :ends_at_time, :datetime_tba, :skill_list, :tool_list, :requirement_list, :other_needs, :hours, :hours_per, :location_address, :location_address2, :location_city, :location_state, :location_zipcode, :location_private, :location_nbrhood, :location_varies, :age_min, :age_max, :registration_min, :registration_max, :price
  before_save :generate_title

  acts_as_taggable
  acts_as_taggable_on :skills, :tools, :requirements

  before_save :fix_tags

  attr_accessible :stripe_card_token
  attr_accessor :stripe_card_token


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
      self.charge_id = charge.id
      logger.info "Processed payment #{charge.id}"
    end 
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def refund_payment
  end

  state_machine :state, :initial => :started do
    
     state :started do
     end
    
     state :pending do
        validates_presence_of :bio, :website, :permission, :description, :begins_at, :skill_list, :tool_list, :location_address, :location_city, :location_state, :location_zipcode, :age_min, :age_max, :registration_min
        validates_numericality_of :age_min, :greater_than => 0
        validates_numericality_of :age_max, :greater_than => :age_min, :message => "must be greater than the minimum age you set."
        validates_numericality_of :registration_min, :greater_than_or_equal_to => 0

        validates_date :begins_at, :on_or_after => :aweektoday, :if => :tba_is_blank # See Restriction Shorthand in config/initializers/validates_timeliness
     end
    
     state :accepted do
     end
    
     state :canceled do
     end

     state :completed do
     end
    
     event :reject do
       transition :pending => :started
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
        transition :accepted => :pending
      end
      
      event :cancel do
        transition all => :canceled
      end   

      event :complete do
        transition :accepted => :completed
      end   
  end

def tba_is_blank 
  !datetime_tba.blank? 
end    

end
