class AppSignup < Signup

  #validation_group :save do
    #should be conditional - validates_presence_of :daughter_firstname
    #should be conditional - validates_presence_of :daughter_lastname
    #should be conditional - validates_numericality_of :daughter_age, :greater_than => :age_min, :message => "Your daughter must be older to apply for this apprenticeship."
  #end
  validation_group :submit do
    validates_presence_of :happywhen, :collaborate, :interest, :experience, :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee, :message => ' must be included in order to submit your form.'
  end
  validation_group :confirm do
    #validates_numericality_of :phone
    # MAKE CONDITIONAL validates_presence_of :parent_name, :parent_phone, :parent_email, :parents_waiver, :respect_agreement, :waiver
    #validates :paid or :confirm_fee ???
  end

  attr_accessible :daughter_firstname, :daughter_lastname, :daughter_age,
                  :happywhen, :collaborate, :interest, :experience,
                  :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee,
                  :age_min, :phone,
                  :parent_name, :parent_phone, :parent_email, :parents_waiver, :respect_agreement, :waiver

  def default_url_options
    { :host => 'localhost:3000'}
  end

  def process_apprent_fee
    logger.info "Processing payment"
    unless charge_id.present?
      charge = Stripe::Charge.create(
        :amount => 2900, # amount in cents, again
        :currency => "usd",
        :card => stripe_card_token,
        :description => "Apprenticeship fee for #{self.event.title} from #{self.user.email}"
      )
      update_attribute(:charge_id, charge.id)
      logger.info "Processed payment #{charge.id}"
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def deliver_save
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your application has been saved - #{self.event.title}",
      :html_body => %(<h1>Yay #{user.first_name}!</h1> <p>We're thrilled you're applying to work with #{self.event.user.first_name}! If you get stuck take a look at our <a href="http://www.girlsguild.com/faq">FAQ</a>, or feel free to respond to this email with any questions you might have!</p> <p>You can edit your application here - <a href="#{url_for(self)}"> Application for #{self.event.title}</a></p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Application for #{event.title}",
      :html_body => %(<h1>Thanks #{user.first_name}!</h1> <p>You've applied for <a href=#{url_for(event)}>#{event.title}</a>. You can see your application <a href=#{url_for(self)}>here</a>. #{event.host_firstname} will review it, and we'll let you know her decision within two weeks.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  def deliver_maker
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.first_name} has applied to work with you!",
      :html_body => %(<h1>Yippee #{event.user.first_name}!</h1> <p>#{user.first_name} has applied to apprentice with you! You can review her application <a href=#{url_for(self)}>here</a>. We've notified #{user.first_name} that you will either accept or decline the application within 2 weeks.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_decline
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.event.user.first_name} reviewed your application",
      :html_body => %(<p>Thanks for your application #{user.first_name}! For this apprenticeship #{self.event.user.first_name} chose a different applicant, but she was super excited that you were interested in working together. We'll let you know about other possibilities for collaboration with her in the future. In the meantime, we hope you'll find another apprenticeship you'd be interested in - check out our <a href="#{url_for(apprenticeships_path)}"> our apprenticeship listings</a></p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  def deliver_decline_maker
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "We've notified #{user.first_name} of your decision",
      :html_body => %(<p>Thanks for making that touch decision. We've notified #{user.first_name} that you declined her application this time. But we let her know that chose a different applicant, but that you were honored that you were interested in working together and that we'd let her know about other possibilities for collaboration with you in the future.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_accept
    Pony.mail({
      :to => "#{self.user.name}<#{self.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.event.user.first_name} would like to work with you!",
      :html_body => %(<h1>Yeehaw #{self.user.first_name}!</h1> <p>We're excited to let you know that #{self.event.user.first_name} has reviewed your application for #{self.event.title} and would like to work with you as her apprentice! To accept the apprenticeship, please fill out the <a href=#{url_for(self)}>confirmation form</a> and submit your apprenticeship fee. If you have any questions feel free to respond to this email.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  def deliver_accept_maker
    Pony.mail({
      :to => "#{event.user.first_name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You've accepted #{user.first_name} as your apprentice!",
      :html_body => %(<h1>Hoorah!</h1> <p>You've accepted #{user.first_name} as your apprentice! We've asked her to accept the apprenticeship by filling out the <a href=#{url_for(self)}>confirmation form</a> and submitting her apprenticeship fee. If you have any questions feel free to respond to this email.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_confirm
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship is ready to start! - #{self.event.title}",
      :html_body => %(<h1>Yesss!</h1> <p>You're all confirmed for #{self.event.title}! (Fill out this email with more info)</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  def deliver_confirm_maker
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship with #{user.first_name} is ready to start! - #{self.event.title}",
      :html_body => %(<h1>Yesss, #{user.first_name} has confirmed the apprenticeship!</h1> <p>You're all set to work with #{user.first_name} for #{self.event.title}! (Fill out this email with more info)</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_reminder
    return false unless valid?
    Pony.mail({
        :to => "#{user.name}<#{user.email}>, #{event.user.name}<#{event.user.email}>",
        :from => "Diana & Cheyenne<hello@girlsguild.com>",
        :reply_to => "GirlsGuild<hello@girlsguild.com>",
        :subject => "Your apprenticeship is set to start soon! - #{self.event.title}",
        :html_body => %(<h1>We're stoked you'll be working together soon!</h1> <p>Just a reminder that your apprenticeship should be starting in a few days (if you haven't connected already). (Fill out this email with more info)</p>),
        :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_followup
    return false unless valid?
    Pony.mail({
        :to => "#{user.name}<#{user.email}>, #{event.user.name}<#{event.user.email}>",
        :from => "Diana & Cheyenne<hello@girlsguild.com>",
        :reply_to => "GirlsGuild<hello@girlsguild.com>",
        :subject => "How's it going? - #{self.event.title}",
        :html_body => %(<h1>Hey #{user.first_name} & #{event.user.first_name}!</h1> <p>How's your apprenticeship going so far? (Fill out this email with more info)</p>),
        :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def self.reminder
    AppSignup.all.each do |app_signup|
      if app_signup.confirmed? && (app_signup.event.begins_at) == (Date.today + 3.days)
        app_signup.deliver_reminder
      end
    end
  end

  def self.followup
    AppSignup.all.each do |app_signup|
      if app_signup.confirmed? && (app_signup.event.begins_at) == (Date.today - 7.days)
        app_signup.deliver_followup
      end
    end
  end

  state_machine :state, :initial => :started do
    event :complete do
      transition :confirmed => :completed
    end
  end
end
