class PaymentError < StandardError; end
class SignupError < StandardError; end

class WorkSignup < Signup
include EventHelper

  attr_accessible :waiver, :interest, :experience,
                  :requirements, :respect_agreement,
                  :daughter_firstname, :daughter_lastname, :daughter_age,
                  :daughter_age_is_valid,
                  :parent_name, :parent_phone, :parent_email, :parents_waiver,
                  :user_id, :event_id, :state, :work_first_reminder_sent, :work_second_reminder_sent

  validates_presence_of :interest, :message => "- Please tell us a bit about what you want to learn in this workshop."
  validates_acceptance_of :requirements, :if => :requirements?

  validate :respect_valid

  validates_presence_of :daughter_firstname, :daughter_lastname, :daughter_age, :parents_waiver, :if => :parent?
  validate :daughter_age_is_valid, :if => :parent?
  validates_acceptance_of :parents_waiver, :if => :parent?

  validates_presence_of :parent_name, :parent_phone, :parent_email, :parents_waiver, :if => :minor?
  validates_acceptance_of :parents_waiver, :message => "Sorry, you must agree to the waiver to sign up.", :if => :minor?

  validates_acceptance_of :waiver, :message => "Sorry, you must agree to the waiver to sign up."

  include Emailable

  def respect_valid
    if self.event.respect_my_style == "1" && !respect_agreement
      errors.add(:respect_agreement, "You must agree to respect the artist's style")
    end
  end

  def daughter_age_is_valid
    unless daughter_age && daughter_age >= self.event.age_min && daughter_age <= self.event.age_max
      errors.add(:daughter_age, "Your daughter must be between #{self.event.age_min} - #{self.event.age_max} to sign up for this workshop.")
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
        :amount => (self.event.price).round.to_i*100, # amount in cents, again
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

  #deliver gets called from webhooks in stripe_controller.rb
  def deliver(opts={})
   if self.parent?
     deliver_parent(opts) && deliver_maker_daughter(opts)
   elsif self.minor?
     deliver_minor(opts) && deliver_maker(opts)
    else
     deliver_self(opts) && deliver_maker(opts)
    end
  end

  def deliver_self(opts={})
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
        <p>
          <b>When:</b> #{get_formated_date(event.begins_at_time, format: "%l:%M %P")} - #{get_formated_date(event.ends_at_time, format: "%l:%M %P")}, #{get_formated_date(event.begins_at, format: "%b %e, %Y")}
          <br/><b>Where:</b> #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}
          <br/><b>Maker's Email:</b> #{event.user.email}
        </p>
        <p>You can review the <a href="#{url_for(self.event)}">workshop details page</a> for more info on what to expect and prepare for, and if by some bad luck it turns out you can't make it, you can cancel your registration on your <a href="#{dashboard_url}">Events Dashboard</a>.
          <br/>Note that you'll need to cancel at least 7 days in advance to have your fee refunded. Let us know if you have any questions!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_minor(opts={})
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
        <p>
          <b>When:</b> #{get_formated_date(event.begins_at_time, format: "%l:%M %P")} - #{get_formated_date(event.ends_at_time, format: "%l:%M %P")}, #{get_formated_date(event.begins_at, format: "%b %e, %Y")}
          <br/><b>Where:</b> #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}
          <br/><b>Maker's Email:</b> #{event.user.email}
        </p>
        <p>You can review the <a href="#{url_for(self.event)}">workshop details page</a> for more info on what to expect and prepare for, and if by some bad luck it turns out you can't make it, you can cancel your registration on your <a href="#{dashboard_url}">Events Dashboard</a>. Note that you'll need to cancel at least 7 days in advance to have your fee refunded. Let us know if you have any questions!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :cc => "#{self.parent_name}<#{self.parent_email}>",
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
        <p>
          <b>When:</b> #{get_formated_date(event.begins_at_time, format: "%l:%M %P")} - #{get_formated_date(event.ends_at_time, format: "%l:%M %P")}, #{get_formated_date(event.begins_at, format: "%b %e, %Y")}
          <br/><b>Where:</b> #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}
          <br/><b>Maker's Email:</b> #{event.user.email}
        </p>
        <p>You can review the <a href="#{url_for(self.event)}">workshop details page</a> for more info on what to expect and prepare for, and if by some bad luck it turns out #{self.daughter_firstname} can't make it, you can cancel her registration on your <a href="#{dashboard_url}">Events Dashboard</a>. Note that you'll need to cancel at least 7 days in advance to have your fee refunded. Let us know if you have any questions!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_maker(opts={})
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.first_name} has signed up for your workshop #{event.topic}",
      :html_body => %(<h1>Woooo #{event.user.first_name}!</h1>
        <p>Congrats, you have a new signup for <a href="#{url_for(self.event)}">#{event.title}</a></p>
        <p>#{user.first_name} - #{user.email}</p>
        <p>Here's what she said about her previous experience with making and her interest in this workshop: "#{self.interest}"</p>
        <p>That makes #{self.event.signups.where(:state => 'confirmed').count} people signed up, and registration closes on #{get_formated_date(self.event.ends_at, format: "%b %e, %Y")}. We'll keep you posted as new signups come in! You can also view who has signed up from your <a href="#{dashboard_url}">Events Dashboard</a>.</p>
        <p>If by some bad luck it turns out you can't host the workshop, you can cancel your workshop from the <a href="#{url_for(self.event)}">workshop details page</a>. (Note that you'll need to cancel at least 7 days in advance so that we can notify your students).</p>
        <p>Let us know if you have any questions!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_maker_daughter(opts={})
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.daughter_firstname} has signed up for your workshop #{event.topic}",
      :html_body => %(<h1>Woooo #{event.user.first_name}!</h1>
        <p>Congrats, you have a new signup for for <a href="#{url_for(self.event)}">#{event.title}</a>. #{user.first_name} signed up their daughter, #{self.daughter_firstname} - #{user.email}.</p>
        <p>Here's what she said about her previous experience with making and her interest in this workshop: "#{self.interest}"</p>
        <p>That makes #{self.event.signups.where(:state => 'confirmed').count} people signed up, and registration closes on #{get_formated_date(self.event.ends_at, format: "%b %e, %Y")}. We'll keep you posted as new signups come in! You can also view who has signed up from your <a href="#{dashboard_url}">Events Dashboard</a>.</p>
        <p>If by some bad luck it turns out you can't host the workshop, you can cancel your workshop from the <a href="#{url_for(self.event)}">workshop details page</a>. (Note that you'll need to cancel at least 7 days in advance so that we can notify your students).</p>
        <p>Let us know if you have any questions!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_destroy
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop signup has been deleted - #{event.title}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've deleted your workshop signup to work with #{self.event.user.first_name}. We hope you'll consider working with #{self.event.user.first_name} or someone else soon.</p>
        <p>Please let us know if there's a way we can help make this signup process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_destroy_parent
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your daughter's workshop signup has been deleted - #{event.title}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've deleted your daughter's signup to work with #{self.event.user.first_name}. We hope you'll consider helping her apply to work with #{self.event.user.first_name} or someone else soon.</p>
        <p>Please let us know if there's a way we can help make this signup process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_cancel
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop has been canceled - #{event.title}",
      :html_body => %(<h1>We're sorry.</h1>
        <p>The workshop on #{event.topic} you signed up for with #{self.event.user.first_name} has been canceled. We'll refund your signup fee, and let you know the next time #{self.event.user.first_name} is hosting a workshop or apprenticeship.</p>
        <p>Please let us know if you have any questions.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end


  def deliver_cancel_self
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You canceled your signup - #{event.title}",
      :html_body => %(<h1>Darn.</h1>
        <p>You canceled your signup for #{self.event.user.first_name}'s workshop on #{event.topic}. If there are at least 7 days before the workshop date, we'll refund your signup fee in the next two days. We hope you'll find another workshop you're interested in, and we'll let you know the next time #{self.event.user.first_name} is hosting a workshop or apprenticeship.</p>
        <p>Please let us know if there's a way we can help make this process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
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
        <p>
          <b>When:</b> #{get_formated_date(event.begins_at_time, format: "%l:%M %P")} - #{get_formated_date(event.ends_at_time, format: "%l:%M %P")}, #{get_formated_date(event.begins_at, format: "%b %e, %Y")}
          <br/><b>Where:</b> #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}
          <br/><b>Maker's Email:</b> #{event.user.email}
        </p>
        <p>Double check the <a href="#{url_for(self.event)}">workshop details page</a> for more info on what to expect and prepare for.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
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
        <p>Just one more reminder that your workshop with #{self.event.user.name} is tomorrow!
        <p>
          <b>When:</b> #{get_formated_date(event.begins_at_time, format: "%l:%M %P")} - #{get_formated_date(event.ends_at_time, format: "%l:%M %P")}, #{get_formated_date(event.begins_at, format: "%b %e, %Y")}
          <br/><b>Where:</b> #{event.location_address} #{event.location_address2}, #{event.location_city}, #{event.location_state}
          <br/><b>Maker's Email:</b> #{event.user.email}
        </p>
        <p>Wondering what to expect? The <a href="#{url_for(self.event)}">workshop details page</a> has all the info.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
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
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:work_followup_sent, true)
    return true
  end

  def self.first_reminder
    date_range = Date.today..(Date.today+3.days)
    WorkSignup.joins(:event).where(events: {:begins_at => date_range}).where(state: 'confirmed', work_first_reminder_sent: false).each do |work|
      work.deliver_first_reminder
    end
  end

  def self.second_reminder
    date_range = Date.today..(Date.today+1.days)
    WorkSignup.joins(:event).where(events: {:begins_at => date_range}).where(state: 'confirmed', work_second_reminder_sent: false).each do |work|
      work.deliver_second_reminder
    end
  end

  def self.followup
    date_range = (Date.today-3.days)..Date.today
    WorkSignup.joins(:event).where(events: {:begins_at => date_range}).where(state: 'completed', work_followup_sent: false).each do |work|
      work.deliver_followup
    end
  end

  def state_label
    if self.started?
      return "saved"
    elsif self.confirmed?
      return "signed up"
    else
      return self.state
    end
  end

  def countdown_message
    if self.started?
      #Commenting out because there is no edit_work_signup_path, and work_signups should never show up as saved
      #return "Your signup is saved. <br/><a href=#{edit_work_signup_path(self)} class='bold'>Finish signing up!</a>".html_safe
    elsif self.canceled?
        return 'You canceled your registration for this workshop'
    elsif self.confirmed?
      if self.event.begins_at && Date.today < self.event.begins_at
        return "<strong>#{(self.event.begins_at.mjd - Date.today.mjd)}</strong> days until your workshop!".html_safe
      elsif self.event.begins_at == Date.today
        return "Your workshop begins today!"
      else
        return ''
      end
    elsif self.completed?
      return "Your workshop is over :-)"
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



