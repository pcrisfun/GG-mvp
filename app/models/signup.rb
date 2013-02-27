class Signup < ActiveRecord::Base

	belongs_to :user
	belongs_to :event

	attr_accessible :collaborate, :happywhen, :interest, :experience, :requirements, :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee, :parent_phone, :parent_name, :parent_email, :waiver, :parents_waiver, :respect_agreement, :charge_id, :parent, :daughter_name, :daughter_age

  attr_accessible :stripe_card_token
  attr_accessor :stripe_card_token


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
