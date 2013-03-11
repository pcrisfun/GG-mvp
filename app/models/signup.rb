class Signup < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor

	belongs_to :user
	belongs_to :event

	attr_accessible :collaborate, :happywhen, :interest, :experience, :requirements, :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee, :parent_phone, :parent_name, :parent_email, :waiver, :parents_waiver, :respect_agreement, :charge_id, :parent, :daughter_name, :daughter_age

  attr_accessible :stripe_card_token
  attr_accessor :stripe_card_token

  state_machine :state, :initial => :started do

    state :started do
    end

    state :pending do
    end

    state :accepted do
    end

    state :declined do
    end

    state :canceled do
    end

    state :confirmed do
    end

    state :in_progress do
    end

    state :completed do
    end

    event :signup do
      transition :started => :confirmed
    end

    event :apply do
      transition :started => :pending
    end

    event :accept do
      transition :pending => :accepted
    end

    event :cancel do
      transition all => :canceled
    end

    event :decline do
      transition :pending => :declined
    end

    event :confirm do
      transition :accepted => :confirmed
    end

  end

end
