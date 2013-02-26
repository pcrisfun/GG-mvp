class Signup < ActiveRecord::Base

	belongs_to :user
	belongs_to :event

	attr_accessible :collaborate, :happywhen, :interest, :experience, :requirements, :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee, :parent_phone, :parent_name, :parent_email, :waiver, :parents_waiver, :respect_agreement, :charge_id, :parent, :daughter_name, :daughter_age

  attr_accessible :stripe_card_token
  attr_accessor :stripe_card_token

  def process_workshop_fee
    logger.info "Processing payment"
    unless charge_id.present?
      charge = Stripe::Charge.create(
        :amount => "#{self.event.price}".to_i/100, # amount in cents, again
        :currency => "usd",
        :card => stripe_card_token,
        :description => "Workshop fee for #{self.event.title} from #{self.user.email}"
      )
      update_attribute(:charge_id, charge.id)
      logger.info "Processed payment #{charge.id}"
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  state_machine :state, :initial => :started do

    state :started do
    end

    state :submitted do
    end

    state :accepted do
    end

    state :canceled do
    end

    state :in_progress do
    end

    state :completed do
    end

    event :submit do
      transition :started => :submitted
    end

    event :accept do
      transition :submitted => :accepted
    end

    event :resubmit do
      transition :accepted => :submitted
    end

    event :cancel do
      transition all => :canceled
    end

    event :in_progress do
      transition :accepted => :in_progress #this will need to be triggered when the apprenticeship is filled
    end
  end

end
