class PaymentError < StandardError; end
class SignupError < StandardError; end

class WorkSignup < Signup

  attr_accessible :waiver, :interest, :experience,
                  :requirements, :respect_agreement,
                  :daughter_firstname, :daughter_lastname, :daughter_age,
                  :daughter_age_is_valid,
                  :parent_name, :parent_phone, :parent_email, :parents_waiver

  validates_presence_of :interest, :experience, :message => ' must be included in order to submit your form.'
  validates_acceptance_of :waiver, :message => ' must agree to submit your form.'

  validates_acceptance_of :requirements, :if => :requirements?
  validates_acceptance_of :respect_agreement, :if => :respect_agreement?

  validates_presence_of :daughter_firstname, :daughter_lastname, :daughter_age, :parents_waiver, :if => :parent?
  validates_acceptance_of :parents_waiver, :if => :parent?
  validate :daughter_age_is_valid, :if => :parent?

  validates_presence_of :parent_name, :parent_phone, :parent_email, :parents_waiver, :if => :minor?
  validates_acceptance_of :parents_waiver, :if => :minor?

  include Emailable

  def respect_valid
    if self.event.respect_my_style == "1" && !respect_agreement
      errors.add(:respect_agreement, "You must agree to respect the artist's style")
    end
  end

  def daughter_age_is_valid
    unless daughter_age && daughter_age >= self.event.age_min && daughter_age <= self.event.age_max
      errors.add(:daughter_age, "Your daughter must be between #{self.event.age_min} - #{self.event.age_max} to apply for this apprenticeship.")
    end
  end

  def parent?
    return self.parent == 'true'
  end

  def minor?
    return !self.user.over_18
  end

  def requirements?
    return self.event.requirement_list.present?
  end

  def respect_agreement?
    return self.event.respect_my_style == 'true'
  end

  # Creates a sign up object, processes payment, and marks sign up
  # process as completed on the sign up object.
  #
  # Returns true if sign up completed successfully, raises exception otherwise.
  def process_signup!
    raise PaymentError unless process_workshop_fee

    #raise SignupError  unless signup
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

  def deliver(opts={})
    payment = opts[:payment]
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You signed up for #{event.topic} with #{event.host_firstname} #{event.host_lastname}",
      :html_body => %(<h1>Yay #{user.first_name}!</h1>
        <p>You're all signed up for <a href="#{url_for(self.event)}">#{event.title}</a>.
        <p>We received your payment of #{sprintf('$%0.2f', payment.amount.to_f / 100.0)}</p>
        <p>Here are the workshop details to remember:</p>
        <p>When: #{event.begins_at_time} - #{event.ends_at_time}, #{event.begins_at}</p>
        <p>Where: #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}</p>
        <p>You can review the <a href="#{url_for(self.event)}">workshop details page</a> for more info on what to expect and prepare for, and if by some bad luck it turns out you can't make it, you can cancel your registration there too (note that you'll need to cancel at least 7 days in advance to have your fee refunded).</p>
        <p>Let us know if you have any questions!</p>
        <p>Thanks and Happy Making!</p>
        <p>the GirlsGuild team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_parent(opts={})
    payment = opts[:payment]
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You signed up for #{event.topic} with #{event.host_firstname} #{event.host_lastname}",
      :html_body => %(<h1>Yay #{user.first_name}!</h1>
        <p>Thanks for helping your daughter, #{self.daughter_firstname} sign up for <a href=#{url_for(event)}>#{event.title}</a>.
        <p>We received your payment of #{sprintf('$%0.2f', payment.amount.to_f / 100.0)}</p>
        <p>Here are the workshop details to remember:</p>
        <p>When: #{event.begins_at_time} - #{event.ends_at_time}, #{event.begins_at}</p>
        <p>Where: #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}</p>
        <p>You can review the <a href="#{url_for(self.event)}">workshop details page</a> for more info on what to expect and prepare for, and if by some bad luck it turns out #{self.daughter_firstname} can't make it, you can cancel her registration there too (note that you'll need to cancel at least 7 days in advance to have your fee refunded).</p>
        <p>Let us know if you have any questions!</p>
        <p>Thanks and Happy Making!</p>
        <p>the GirlsGuild team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_maker
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.first_name} has signed up for your workshop #{event.topic}",
      :html_body => %(<h1>Woooo #{event.user.first_name}!</h1>
        <p>Congrats, #{user.first_name} signed up for <a href="#{url_for(self.event)}">#{event.title}</a>.
        <p>Here are the workshop details to remember:</p>
        <p>When: #{event.begins_at_time} - #{event.ends_at_time}, #{event.begins_at}</p>
        <p>Where: #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}</p>
        <p>You can review the <a href="#{url_for(self.event)}">workshop details page</a> or check out <a href="#{dashboard_url}">your dashboard</a> to keep tabs on who's signing up, and if by some bad luck it turns out you can't make it, you can cancel your workshop there too (note that you'll need to cancel at least 7 days in advance so that we can notify your students).</p>
        <p>Let us know if you have any questions!</p>
        <p>Thanks and Happy Making!</p>
        <p>the GirlsGuild team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_destroy
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop signup has been canceled - #{event.topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've canceled your workshop signup to work with #{self.event.user.first_name}. We hope you'll consider working with #{self.event.user.first_name} or someone else soon.</p>
        <p>Please let us know if there's a way we can help make this signup process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_destroy_parent
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your daughter's workshop signup has been canceled - #{event.topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've deleted your daughter's signup to work with #{self.event.user.first_name}. We hope you'll consider helping her apply to work with #{self.event.user.first_name} or someone else soon.</p>
        <p>Please let us know if there's a way we can help make this signup process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end




  def deliver_first_reminder
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop is coming up! - #{self.event.title}",
      :html_body => %(<h1>Just a few days!</h1>
        <p>Just a reminder that you're signed up for <a href="#{url_for(self.event)}">#{event.title}</a>.</p>
        <p>It's happening on #{self.event.begins_at} from #{self.event.begins_at_time} to #{self.event.ends_at_time}, at #{self.event.location_address} #{self.event.location_address2} in #{self.event.location_city}.</p>
        <p>Double check the <a href="#{url_for(self.event)}">workshop details page</a> for more info on what to expect and prepare for.</p>
        <p>Thanks and Happy Making!</p>
        <p>the GirlsGuild team</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:work_first_reminder_sent, true)
    return true
  end

  def deliver_second_reminder
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop is tomorrow! - #{self.event.title}",
      :html_body => %(<h1>Almost time!</h1>
        <p>Just one more reminder that your workshop with #{self.event.user.name} is tomorrow, #{self.event.begins_at} from #{self.event.begins_at_time} to #{self.event.ends_at_time}.</p>
        <p>The address is: #{self.event.location_address} #{self.event.location_address2}, #{self.event.location_city}.</p>
        <p>Wondering what to expect? The <a href="#{url_for(self.event)}">workshop details page</a> has all the info.</p>
        <p>Thanks and Happy Making!</p>
        <p>the GirlsGuild team</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:work_second_reminder_sent, true)
    return true
  end

  def deliver_followup
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "How was your workshop? - #{self.event.title}",
      :html_body => %(<h1>Hey #{user.first_name}!</h1>
        <p>What did you think of #{self.event.title}? Do you have any feedback, good or bad, about the experience? We'd love to hear it.</p>
        <p>And of course, if you have any questions or concerns, don't hesitate to ask!</p>
        <p>Thanks and Happy Making!</p>
        <p>the GirlsGuild team</p>),
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

  def countdown_message
    if self.started?
    elsif self.canceled?
        return 'You canceled your registration for this workshop'
    elsif self.confirmed?
      if self.event.begins_at && Date.today < self.event.begins_at
        return "<strong>#{(self.event.begins_at.mjd - Date.today.mjd)}</strong> days until your workshop!".html_safe
      else
        return false
      end
    elsif self.completed?
    else
    end
    return ''
  end

  def countdown_message_maker
    if self.started?
    elsif self.pending?
    elsif self.accepted?
    elsif self.declined?
    elsif self.canceled?
    elsif self.confirmed?
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



