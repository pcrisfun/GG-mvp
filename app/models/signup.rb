class Signup < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor

	belongs_to :user
	belongs_to :event
  has_many :state_stamps

	attr_accessible :collaborate, :happywhen, :interest, :experience, :requirements, :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee, :parent_phone, :parent_name, :parent_email, :waiver, :parents_waiver, :respect_agreement, :charge_id, :parent, :daughter_name, :daughter_age, :stripe_card_token
  attr_accessor :stripe_card_token

  def make_stamp
    self.state_stamps.create(state: self.state, stamp: Date.today)
  end

  state_machine :state, :initial => :started do

    after_transition any => any do |event|
      event.make_stamp
    end

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

    state :interview_requested do
    end

    state :interview_scheduled do
    end

    state :confirmed do
    end

    state :completed do
    end


    event :signup do #This is when someone submits a workshop signup
      transition :started => :confirmed
    end

    event :apply do
      transition :started => :pending
    end

    event :accept do
      transition all => :accepted
    end

    event :cancel do
      transition all => :canceled
    end

    event :decline do
      transition all => :declined
    end

    event :confirm do
      transition :accepted => :confirmed
    end

    after_transition :on => :signup, :do => :check_capacity
    after_transition :on => :confirm, :do => :check_capacity
  end

  def check_capacity
    if self.event.max_capacity_met? && !self.event.filled?
      self.event.fill! 
    end
  end

  def state_label_class
    labels = { started: "started",
               pending: "pending",
               interview_requested: "interviewing",
               interview_scheduled: "interviewing",
               accepted: "accepted",
               declined: "declined",
               confirmed: "confirmed",
               canceled: "canceled",
               completed: "completed"
             }
    return labels[self.state.to_sym]
  end

end
