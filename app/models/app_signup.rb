class AppSignup < Signup

#  validation_group :parent_save do
#    validates_presence_of :daughter_firstname, :daughter_lastname, :daughter_age
#    validate :daughter_age_is_valid
#  end
  validation_group :save do
  end
#  validation_group :submit do
#    validates_presence_of :happywhen, :collaborate, :interest, :experience, :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee, :message => ' must be included in order to submit your form.'
#  end
#  validation_group :confirm do
#    #validates_numericality_of :phone
#    validates_presence_of :waiver
#    validate :respect_valid
#  end
#  validation_group :parent_confirm do
#    validates_presence_of :parent_name, :parent_phone, :parent_email, :parents_waiver
#  end
  attr_accessible :daughter_firstname, :daughter_lastname, :daughter_age,
                  :happywhen, :collaborate, :interest, :experience,
                  :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee,
                  :parent, :parent_name, :parent_phone, :parent_email, :parents_waiver, :respect_agreement, :waiver

  def default_url_options
    { :host => 'localhost:3000'}
  end

  def respect_valid
    if self.event.respect_my_style && !respect_agreement
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
  def deliver_save_parent
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your daughter's application has been saved - #{self.event.title}",
      :html_body => %(<h1>Yay #{user.first_name}!</h1> <p>We're thrilled you're helping your daughter apply to work with #{self.event.user.first_name}! If you get stuck take a look at our <a href="http://www.girlsguild.com/faq">FAQ</a>, or feel free to respond to this email with any questions you might have!</p> <p>You can edit your application here - <a href="#{url_for(self)}"> Application for #{self.event.title}</a></p>),
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
      :subject => "Thanks for applying for #{event.title}",
      :html_body => %(<h1>Thanks #{user.first_name}!</h1> <p>You've applied for <a href=#{url_for(event)}>#{event.title}</a>. You can see your application <a href=#{url_for(self)}>here</a>. #{event.host_firstname} will review it, and we'll let you know her decision within two weeks.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  def deliver_parent
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Thanks for helping your daughter apply for #{event.title}",
      :html_body => %(<h1>Thanks #{user.first_name}!</h1> <p>Thanks for helping your daughter, #{self.daughter_firstname} apply for <a href=#{url_for(event)}>#{event.title}</a>. You can see her application <a href=#{url_for(self)}>here</a>. #{event.host_firstname} will review it, and we'll let you know her decision within two weeks.</p>),
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

  def deliver_destroy
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your application has been deleted - #{event.topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1> <p>You've deleted your application to work with #{self.event.user.first_name}. We hope you'll re-consider applying to work with #{self.event.user.first_name} or someone else.</p> <p> Please let us know if there's a way we can help make this application process easier by simply replying to this email. We would really appreciate your feedback!</a></p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  def deliver_destroy_parent
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your daughter's application has been deleted - #{event.topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1> <p>You've deleted your daughter's application to work with #{self.event.user.first_name}. We hope you'll re-consider helping her apply to work with #{self.event.user.first_name} or someone else.</p> <p> Please let us know if there's a way we can help make this application process easier by simply replying to this email. We would really appreciate your feedback!</a></p>),
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
  def deliver_decline_parent
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.event.user.first_name} reviewed your daughter's application",
      :html_body => %(<p>Thanks for #{self.daughter_firstname}'s application! For this apprenticeship #{self.event.user.first_name} chose a different applicant, but she was super excited that you were interested in working together. We'll let you know about other possibilities for collaboration with her in the future. In the meantime, we hope you and #{self.daughter_firstname} will find another apprenticeship you'd be interested in - check out our <a href="#{url_for(apprenticeships_path)}"> our apprenticeship listings</a></p>),
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
      :html_body => %(<p>Thanks for making that tough decision. We've notified #{user.first_name} that you chose a different applicant, but that you were honored that she was interested in working together and that we'll let her know about other possibilities for collaboration with you in the future.</p>),
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
      :html_body => %(<h1>Yeehaw #{self.user.first_name}!</h1> <p>We're excited to let you know that #{self.event.user.first_name} has reviewed your application for #{self.event.title} and would like to work with you as her apprentice! To accept the apprenticeship, please fill out the <a href=#{url_for(self)}>confirmation form</a> and submit the $9.00 apprenticeship fee. If you have any questions feel free to respond to this email.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  def deliver_accept_parent
    Pony.mail({
      :to => "#{self.user.name}<#{self.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.event.user.first_name} would like to work with #{self.daughter_firstname}!",
      :html_body => %(<h1>Yeehaw!</h1> <p>We're excited to let you know that #{self.event.user.first_name} has reviewed your daughter's application for #{self.event.title} and would like to work with #{self.daughter_firstname} as her apprentice! To accept the apprenticeship, please fill out the <a href=#{url_for(self)}>confirmation form</a> and submit the $9.00 apprenticeship fee. If you have any questions feel free to respond to this email.</p>),
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
  def deliver_confirm_parent
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship is ready to start! - #{self.event.title}",
      :html_body => %(<h1>Yesss!</h1> <p>#{self.daughter_firstname} is all confirmed for #{self.event.title}! (Fill out this email with more info)</p>),
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

  state_machine :state, :initial => :started do
    state :started do
    end

    state :pending do
      validates_presence_of :happywhen, :collaborate, :interest, :experience, :preferred_times, :message => ' must be included in order to submit your form.'
      validates_acceptance_of :confirm_available, :confirm_unpaid, :confirm_fee, :message => ' must agree to submit your form.'
      validates_presence_of :daughter_firstname, :daughter_lastname, :daughter_age, :if => :parent?
      validate :daughter_age_is_valid, :if => :parent?
    end

    state :accepted do
    end

    state :declined do
    end

    state :canceled do
    end

    state :confirmed do
      validates_presence_of :waiver
      validate :respect_valid
      #validates_numericality_of :phone
      validates_presence_of :parent_name, :parent_phone, :parent_email, :parents_waiver, :if => :parent?
    end

    state :completed do
    end

    event :complete do
      transition :confirmed => :completed
    end
  end
end
