class PaymentError < StandardError; end
class SignupError < StandardError; end

class WorkSignup < Signup

  validates :waiver, :acceptance => true

  include Emailable

  # Creates a sign up object, processes payment, and marks sign up
  # process as completed on the sign up object.
  #
  # Returns true if sign up completed successfully, raises exception otherwise.
  def process_signup!
    raise PaymentError unless process_workshop_fee
    raise SignupError  unless signup
  end

  def process_workshop_fee
    logger.info "Processing payment"
    unless charge_id.present?
      charge = Stripe::Charge.create(
        :amount => (self.event.price*1.2*100).to_i, # amount in cents, again
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

  def deliver_confirm(opts={})
    return false unless valid?

    payment = opts[:payment]

    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
          :from => "GirlsGuild<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You signed up for #{event.topic} with #{event.host_firstname} #{event.host_lastname}",
      :html_body => %(<h1>Yay #{user.first_name}!</h1>
      <p>You're all signed up for <a href="#{url_for(self.event)}">#{event.title}</a>.
      <p>We received your payment of #{sprintf('$%0.2f', payment.amount.to_f / 100.0)}</p>
      <p>(Fill out this email with more info like: where -- link to map, when, contact info for questions, what to be prepared for, what to bring, cancellation policy, the fact that we'll send a text reminder the day before and link to change her phone number. )</p>,
      ), :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_first_reminder
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop is coming up! - #{self.event.title}",
      :html_body => %(<h1>Just a few days!</h1> <p>Just a reminder that you're signed up for #{self.event.title} on #{self.event.begins_at}. (Fill out this email with more info)</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:work_first_reminder_sent, true)
    return true
  end

  def deliver_second_reminder
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop is tomorrow! - #{self.event.title}",
      :html_body => %(<h1>Almost time!</h1> <p>Just a reminder that your workshop with #{self.event.user.name} is tomorrow. (Fill out this email with more info)</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:work_second_reminder_sent, true)
    return true
  end

  def deliver_followup
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "How was your workshop? - #{self.event.title}",
      :html_body => %(<h1>Hey #{user.first_name}!</h1> <p>What did you think of #{self.event.title}? (Fill out this email with more info)</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:work_followup_sent, true)
    return true
  end

  def self.first_reminder
    WorkSignup.where(:state => 'confirmed').where('event.begins_at >= ?', 3.days).where(:work_first_reminder_sent => false).each do |work|
      work.deliver_first_reminder
    end
  end

  def self.second_reminder
    WorkSignup.where(:state => 'confirmed').where('event.begins_at >= ?', 1.day).where(:work_second_reminder_sent => false).each do |work|
      work.deliver_second_reminder
    end
  end

  def self.followup
    WorkSignup.where(:state => 'confirmed').where('event.begins_at <= ?', 3.days.ago).where(:work_followup_sent => false).each do |work|
      work.deliver_followup
    end
  end

  # TODO: Since this is directly reproduced in AppSignup, we probably need a parent class for the two to house
  # these methods.
  def countdown_message
    if self.started?
    elsif self.pending?
      return "Your application is being reviewed. You should hear back by <strong>#{(self.state_stamps.last.stamp + 14.days).strftime("%b %d")}</strong>".html_safe
    elsif self.accepted?
      return "Your application has been accepted!<br/><a href=#{url_for(self)} class='btn btn-success btn-mini'>Confirm</a> your apprenticeship!".html_safe
    elsif self.declined?
    elsif self.canceled?
    elsif self.confirmed?
      if self.event.datetime_tba
        return ''
      elsif self.event.begins_at && Date.today < self.event.begins_at
        return "<strong>#{(self.event.begins_at.mjd - Date.today.mjd)}</strong> days until your apprenticeship begins!".html_safe
      elsif self.event.ends_at && Date.today < self.event.ends_at
        return "#{self.event.ends_at - Date.today} more days of your Apprenticeship"
      else
        return false
      end
    elsif self.completed?
    else
    end
    return ''
  end

  state_machine :state, :initial => :started do
    event :complete do
      transition :confirmed => :completed
    end
  end
end



