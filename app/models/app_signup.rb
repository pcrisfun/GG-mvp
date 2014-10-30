class AppSignup < Signup

  has_many :interviews

  attr_accessible :daughter_firstname, :daughter_lastname, :daughter_age,
                  :happywhen, :collaborate, :interest, :experience,
                  :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee,
                  :parent, :parent_name, :parent_phone, :parent_email, :parents_waiver, :respect_agreement, :waiver, :decline_reason,
                  :event_id, :state, :maker_charge_id

  include Emailable

  validation_group :save do
  end

  validation_group :apply do
    validates_presence_of :happywhen, :collaborate, :interest, :experience, :preferred_times, :message => ' must be included in order to submit your form.'
    validates_acceptance_of :confirm_available, :confirm_unpaid, :message => ' must agree to submit your form.'
    validates_presence_of :daughter_firstname, :daughter_lastname, :daughter_age, :if => :parent?
    validate :daughter_age_is_valid, :if => :parent?
    validates_acceptance_of :requirements, :if => :requirements?
    validates_presence_of :parent_name, :parent_phone, :parent_email, :if => :minor?
    validates_acceptance_of :parents_waiver, :message => "Sorry, you must agree to the indemnification agreement.", :if => :minor? || :parent?
    validates_acceptance_of :waiver, :message => "Sorry, you must agree to the waiver."
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
    if self.event.respect_my_style == "1"
      return true
    end
  end

  def ready_to_apprentice?
    if self.accepted? or self.confirmed? or self.completed?
      return true
    end
  end

  def assign_personal_contact
    if self.id.odd?
      self.personal_contact_name = "Cheyenne"
      self.personal_contact_email = "cheyenne@girlsguild.com"
      self.save!
    elsif self.id.even?
      self.personal_contact_name = "Diana"
      self.personal_contact_email = "diana@girlsguild.com"
      self.save!
    end
  end

  def save_payment_info
    logger.info "Saving payment info"
    if user.stripe_customer_id.present?
      logger.info "Customer already exists"
    else
      logger.info "Creating customer"
      customer = Stripe::Customer.create(
        :card => stripe_card_token,
        :description => user.email
      )
      x = customer.id
      self.user.stripe_customer_id = x
      self.user.save!
    end
  end

  def process_apprent_fee
    logger.info "Processing apprentice payment"
    unless charge_id.present?
      charge = Stripe::Charge.create(
        :amount => 3000, # amount in cents, again
        :currency => "usd",
        :customer => user.stripe_customer_id,
        :description => "Apprenticeship fee for #{self.event.title} from #{self.user.email}"
      )
      logger.debug(charge)
      x = charge.id
      self.charge_id = x
      self.save!
      # update_attribute(:charge_id, charge.id)
      logger.info "Processed apprentice payment #{charge.id}"
    else
      return
    end
  rescue Stripe::CardError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    #errors.add :base, e.message
    false
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating charge: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def process_maker_fee
    logger.info "Processing maker payment"
    unless maker_charge_id.present?
      charge = Stripe::Charge.create(
        :amount => 3000, # amount in cents, again
        :currency => "usd",
        :customer => event.user.stripe_customer_id,
        :description => "Maker payment from #{self.event.user.email} for #{self.user.first_name}'s apprenticeship"
      )
      logger.debug(charge)
      x = charge.id
      self.maker_charge_id = x
      self.save!
      logger.info "Processed maker payment #{charge.id}"
    end
    rescue Stripe::CardError => e
      logger.error "Stripe error while creating charge: #{e.message}"
      #errors.add :base, e.message
      false
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating charge: #{e.message}"
      #errors.add :base, "There was a problem with your credit card."
      false
  end

  def process_auto_payment
    if self.process_apprent_fee
      if self.confirm
        self.assign_personal_contact
        self.deliver_confirm_auto
        self.process_maker_fee
        if self.maker_charge_id.present?
          self.deliver_confirm_maker_auto
        else
          self.deliver_maker_payment_failed
        end
        logger.info "#{self.user.first_name}'s signup for #{self.event.title} has been confirmed. Maker and apprentice payments were processed."
      else
        logger.error "State transition to 'Confirmed' failed: App Signup #{self.id}, #{self.user.first_name}"
      end
    else
      self.deliver_apprentice_payment_failed
      logger.error "#{self.user.first_name}'s payment for #{self.event.title} failed. App Signup #{self.id} has not been confirmed."
    end
  end

  def deliver_save
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your application has been saved - #{self.event.title}",
      :html_body => %(<h1>Yay #{user.first_name}!</h1>
        <p>We're thrilled you're applying to work with #{self.event.user.first_name}! If you get stuck take a look at our <a href="#{faq_url}">FAQ</a>, or feel free to respond to this email with any questions you might have!</p>
        <p><u>Please add hello@girlsguild.com to your address book so nothing hits your spam folder!</u></p>
        <p>You can edit your application here - <a href="#{url_for(self)}"> Application for #{self.event.title}</a></p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
      :html_body => %(<h1>Yay #{user.first_name}!</h1>
        <p>We're thrilled you're helping your daughter apply to work with #{self.event.user.first_name}! If you get stuck take a look at our <a href="#{faq_url}">FAQ</a>, or feel free to respond to this email with any questions you might have!</p>
        <p><u>Please add hello@girlsguild.com to your address book so nothing hits your spam folder!</u></p>
        <p>You can edit your application here - <a href="#{url_for(self)}"> Application for #{self.event.title}</a></p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver(opts={})
    parent? ? deliver_parent(opts) : deliver_girl(opts)
  end

  def deliver_girl(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Thanks for applying for #{event.title}",
      :html_body => %(<h1>Righteous!</h1>
        <p>You've applied for <a href=#{url_for(event)}>#{event.title}</a>. You can see your application <a href=#{url_for(self)}>here</a>.
        <br/>
        We'll send #{event.user.first_name} your application right away and let you know as soon as she makes her decision within 2 weeks. She may decide she'd like to meet up first. If so, we'll email you to confirm a good time. Until then, hold tight and be proud of your awesomeness!</p>
        <p>We've sucessfully received your billing information, but we won't charge you until you've been accepted. You'll still have the chance to cancel your application, but if you don't cancel within a week of being accepted, we'll assume you've begun working together and will go ahead and charge your credit card.</p>
        <p><u>Please add hello@girlsguild.com to your address book so nothing hits your spam folder!</u></p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_parent(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Thanks for helping your daughter apply for #{event.title}",
      :html_body => %(<h1>Thanks #{user.first_name}!</h1>
        <p>Thanks for helping your daughter, #{self.daughter_firstname} apply for <a href=#{url_for(event)}>#{event.title}</a>. You can see her application <a href=#{url_for(self)}>here</a>.
        <br/>
        We'll send #{event.user.first_name} her application right away and let you know as soon as she makes her decision within 2 weeks. She may decide she'd like to meet up first. If so, we'll email you to confirm a good time.
        <p>We've sucessfully received your billing information, but we won't charge you until you've been accepted. You'll still have the chance to cancel your application, but if you don't cancel within a week of being accepted, we'll assume you've begun working together and will go ahead and charge your credit card.</p>
        <p><u>Please add hello@girlsguild.com to your address book so nothing hits your spam folder!</u></p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_maker(opts={})
    parent? ? deliver_maker_daughter(opts) : deliver_maker_girl(opts)
  end

  def deliver_maker_girl(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.first_name} has applied to work with you!",
      :html_body => %(<h1>Yippee #{event.user.first_name}!</h1>
        <p>#{user.first_name} has applied to apprentice with you! You can review her application <a href=#{url_for(self)}>here</a>. We've notified #{user.first_name} that you'll make your decision on the application within 2 weeks.</p>
        <p>If you'd like to meet up with her in person before you decide to accept or decline her application you can <a href=#{url_for(self)}>"Request an Interview"</a>.</p>
        <p>Once you've made your decision, just go back to the <a href=#{url_for(self)}>application page</a> and use the "Accept" or "Decline" buttons to make the call. If you decline the application, we'll send a gentle email letting her know. If you accept the application, we'll charge the $30 matching fee (unless she cancels within a week), and we'll put you two in touch to get started!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_maker_daughter(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.daughter_firstname} has applied to work with you!",
      :html_body => %(<h1>Yippee #{event.user.first_name}!</h1>
        <p>#{user.first_name} has helped their daughter, #{self.daughter_firstname}, apply to apprentice with you! You can review her application <a href=#{url_for(self)}>here</a>. We've notified #{user.first_name} and #{self.daughter_firstname} that you'll make your decision on the application within 2 weeks.</p>
        <p>If you'd like to meet up with her in person before you decide to accept or decline her application you can <a href=#{url_for(self)}>"Request an Interview"</a>.</p>
        <p>Once you've made your decision, just go back to the <a href=#{url_for(self)}>application page</a> and use the "Accept" or "Decline" buttons to make the call. If you decline the application, we'll send a gentle email letting her know. If you accept the application, we'll charge the $30 matching fee (unless she cancels within a week), and we'll put you two in touch to get started!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_cancel(opts={})
    parent? ? deliver_cancel_parent(opts) : deliver_cancel_girl(opts)
  end

  def deliver_cancel_girl(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your application has been canceled - #{event.topic} with #{event.user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've canceled your application to work with #{self.event.user.first_name}. We hope you'll consider applying to work with someone else!</p>
        <p>Please let us know if there's a way we can help make this application process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_cancel_parent(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your daughter's application has been canceled - #{event.topic} with #{event.user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've canceled your daughter's application to work with #{self.event.user.first_name}. We hope you'll consider helping her apply to work with someone else!</p>
        <p>Please let us know if there's a way we can help make this application process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_cancel_maker
    Pony.mail({
      :to => "#{self.event.user.name}<#{self.event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.name} has canceled her application for #{event.topic}",
      :html_body => %(<h1>Shucks</h1>
        <p>#{user.name} has canceled her application for #{event.topic}.</p> You can check open applications on your <a href="#{dashboard_url}">Events Dashboard</a>.
        <p>Please let us know if there's a way we can help make this process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_cancel_bymaker
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{event.user.name} has canceled this apprenticeship - #{event.topic}",
      :html_body => %(<h1>We're sorry</h1>
        <p>The apprenticeship #{event.topic}, you signed up for with #{self.event.user.first_name} has been canceled. We'll let you know the next time #{self.event.user.first_name} is hosting a workshop or apprenticeship.</p>
        <p>Please let us know if there's a way we can help make this process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_resubmit(opts={})
    parent? ? deliver_resubmit_parent(opts) : deliver_resubmit_girl(opts)
  end

  def deliver_resubmit_girl(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Thanks for re-applying for #{event.title}",
      :html_body => %(<h1>Rad!</h1>
        <p>We're glad you resubmitted your application for <a href=#{url_for(event)}>#{event.title}</a>. You can see your application <a href=#{url_for(self)}>here</a>.
        <br/>
        We'll send #{event.user.first_name} your application right away and let you know as soon as she makes her decision within 2 weeks. She may decide she'd like to meet up first. If so, we'll email you to confirm a good time. Until then, hold tight and be proud of your awesomeness! </p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_resubmit_parent(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Thanks for helping your daughter re-apply for #{event.title}",
      :html_body => %(<h1>Thanks #{user.first_name}!</h1>
        <p>Thanks for helping your daughter, #{self.daughter_firstname} resubmit her application for <a href=#{url_for(event)}>#{event.title}</a>. You can see her application <a href=#{url_for(self)}>here</a>.
        <br/>
        We'll send #{event.user.first_name} her application right away and let you know as soon as she makes her decision within 2 weeks. She may decide she'd like to meet up first. If so, we'll email you to confirm a good time.
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_resubmit_maker(opts={})
    parent? ? deliver_resubmit_maker_daughter(opts) : deliver_resubmit_maker_girl(opts)
  end

  def deliver_resubmit_maker_girl(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.first_name} has re-applied to work with you!",
      :html_body => %(<h1>Yippee #{event.user.first_name}!</h1>
        <p>#{user.first_name} resubmitted her application to apprentice with you! You can review her application <a href=#{url_for(self)}>here</a>. We've notified #{user.first_name} that you'll make your decision on the application within 2 weeks.</p>
        <p>If you'd like to meet up with her in person before you decide to accept or decline her application you can <a href=#{url_for(self)}>"Request an Interview"</a>.</p>
        <p>Once you've made your decision, just go back to the <a href=#{url_for(self)}>application page</a> and use the "Accept" or "Decline" buttons to make the call. If you decline the application, we'll send a gentle email letting her know. If you accept the application, we'll charge the $30 matching fee (unless she cancels within a week), and we'll put you two in touch to get started!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_resubmit_maker_daughter(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.daughter_firstname} has applied to work with you!",
      :html_body => %(<h1>Yippee #{event.user.first_name}!</h1>
        <p>#{user.first_name} has helped their daughter, #{self.daughter_firstname}, resubmit her application to apprentice with you! You can review her application <a href=#{url_for(self)}>here</a>. We've notified #{user.first_name} and #{self.daughter_firstname} that you'll make your decision on the application within 2 weeks.</p>
        <p>If you'd like to meet up with her in person before you decide to accept or decline her application you can <a href=#{url_for(self)}>"Request an Interview"</a>.</p>
        <p>Once you've made your decision, just go back to the <a href=#{url_for(self)}>application page</a> and use the "Accept" or "Decline" buttons to make the call. If you decline the application, we'll send a gentle email letting her know. If you accept the application, we'll charge the $30 matching fee (unless she cancels within a week), and we'll put you two in touch to get started!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end


  def deliver_destroy(opts={})
    parent? ? deliver_destroy_parent(opts) : deliver_destroy_girl(opts)
  end

  def deliver_destroy_girl(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your application has been deleted - #{event.topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've deleted your application to work with #{self.event.user.first_name}. We hope you'll re-consider applying to work with #{self.event.user.first_name} or someone else.</p>
        <p>Please let us know if there's a way we can help make this application process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_destroy_parent(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your daughter's application has been deleted - #{event.topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've deleted your daughter's application to work with #{self.event.user.first_name}. We hope you'll re-consider helping her apply to work with #{self.event.user.first_name} or someone else.</p>
        <p>Please let us know if there's a way we can help make this application process easier by simply replying to this email. We would really appreciate your feedback!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_decline(opts={})
    parent? ? deliver_decline_parent(opts) : deliver_decline_girl(opts)
  end

  def deliver_decline_girl(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{event.user.first_name} filled the apprenticeship",
      :html_body => %(<p>Thanks for your application #{user.first_name}. For this apprenticeship #{event.user.first_name} chose a different applicant, but she was honored that you were interested in working together. We'll let you know about other possibilities for collaboration with her in the future!</p>
        <p>In the meantime, we hope you'll find another apprenticeship you'd be interested in - check out our <a href="#{url_for(apprenticeships_path)}"> our apprenticeship listings</a> to see what's available.</p>
        <p>#{self.include_decline_reason}</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
  #=link_to( "Follow this Maker #{content_tag(:i, "", class: "fa fa-eye")}".html_safe, preregs_path(event_id: event), method: 'POST', class: 'btn btn-block')
  #<p><a href="#{preregs_path(event_id: event, method: 'POST')}">Follow this Maker</a></p>


  def deliver_decline_parent(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.event.user.first_name} filled the apprenticeship",
      :html_body => %(<p>Thanks for #{self.daughter_firstname}'s application! For this apprenticeship #{self.event.user.first_name} chose a different applicant, but she was super excited that your daughter was interested in working together. We'll let you know about other possibilities for collaboration with her in the future.</p>
        <p>In the meantime, we hope you and #{self.daughter_firstname} will find another apprenticeship you'd be interested in - check out our <a href="#{url_for(apprenticeships_path)}"> our apprenticeship listings</a> to see what's available.</p>
        <p>#{self.include_decline_reason}</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_decline_maker(opts={})
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "We've notified #{user.first_name} of your decision",
      :html_body => %(<p>Thanks for making that tough decision. We've notified #{user.first_name} that you chose a different applicant, but that you were honored that she was interested in working together and we'll let her know about other possibilities for collaboration with you in the future.</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_accept(opts={})
    parent? ? deliver_accept_parent(opts) : deliver_accept_girl(opts)
  end

  def deliver_accept_girl(opts={})
    Pony.mail({
      :to => "#{self.user.name}<#{self.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.event.user.first_name} would like to work with you!",
      :html_body => %(<h1>Yeehaw #{self.user.first_name}!</h1>
        <p>We're excited to let you know that #{self.event.user.first_name} has reviewed your application for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a> and would like to work with you as her apprentice!</p>
        <h3>Next Steps</h3>
        <p>If you haven't met up yet, you can get in touch with #{self.event.user.name} by email at #{self.event.user.email} to plan your first meeting together. The apprenticeship will be happening at:
        <ul><li>#{self.event.location_address}, #{self.event.location_city}, #{self.event.location_state}</li></ul>
        <p>Please download and print the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> to bring with you - it covers some guidelines for the apprenticeship.</p>
        <p>You can review the <a href="#{apprenticeship_url(self)}">apprenticeship details page</a> for more info on what to expect and prepare for, or check out our <a href="http://girlsguild.com/handbook/GirlsGuildHandbook.pdf">Apprenticeship Handbook</a> for ideas on how to get the most out of your apprenticeship experience.</p>
        <h3>Payment & Cancellation</h3>
        <p>In case you decide not to take on the apprenticeship, you have <strong>7 days to cancel</strong> your application via your <a href="#{dashboard_url}">Events Dashboard</a>. If you don't cancel within a week of being accepted, we'll assume you've begun working together and will go ahead with confirmation by charging your credit card for the $30.00 apprenticeship fee.</p>
        <p>If you need to update your billing information, you can do so <a href="#{billing_url}">here</a>. Just so you know, this fee is your commitment to take on the apprenticeship, so once you've paid, we don't offer a refund.</p>
        <h3>Questions or Feedback?</h3>
        <p>If you have any questions or feedback, just respond to this email - we're here to support you throughout your apprenticeship!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_accept_parent(opts={})
    Pony.mail({
      :to => "#{self.user.name}<#{self.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{self.event.user.first_name} would like to work with #{self.daughter_firstname}!",
      :html_body => %(<h1>Yeehaw!</h1>
        <p>We're excited to let you know that #{self.event.user.first_name} has reviewed your daughter's application for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a> and would like to work with #{self.daughter_firstname} as her apprentice!</p>
        <h3>Next Steps</h3>
        <p>If they haven't met up yet, you can get in touch with #{self.event.user.name} by email at #{self.event.user.email} to plan their first meeting together. The apprenticeship will be happening at:
        <ul><li>#{self.event.location_address}, #{self.event.location_city}, #{self.event.location_state}</li></ul>
        <p>Please download and print the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> to bring with you - it covers some guidelines for the apprenticeship.</p>
        <p>You can review the <a href="#{apprenticeship_url(self)}">apprenticeship details page</a> for more info on what to expect and prepare for, or check out our <a href="http://girlsguild.com/handbook/GirlsGuildHandbook.pdf">Apprenticeship Handbook</a> for ideas on how to get the most out of your apprenticeship experience.</p>
        <h3>Payment & Cancellation</h3>
        <p>In case you and #{self.daughter_firstname} decide not to take on the apprenticeship, you have <strong>7 days to cancel</strong> her application via your <a href="#{dashboard_url}">Events Dashboard</a>. If you don't cancel within a week of being accepted, we'll assume they've begun working together and will go ahead with confirmation by charging your credit card for the $30.00 apprenticeship fee.</p>
        <p>If you need to update your billing information, you can do so <a href="#{billing_url}">here</a>. Just so you know, this fee is your commitment to take on the apprenticeship, so once you've paid, we don't offer a refund.</p>
        <h3>Questions or Feedback?</h3>
        <p>If you have any questions just respond to this email - we're here to support you throughout your apprenticeship!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_accept_maker(opts={})
    parent? ? deliver_accept_maker_daughter(opts) : deliver_accept_maker_girl(opts)
  end

  def deliver_accept_maker_girl(opts={})
    Pony.mail({
      :to => "#{event.user.first_name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You've accepted #{user.first_name} as your apprentice!",
      :html_body => %(<h1>Hoorah!</h1>
        <p>You've accepted #{user.first_name} as your apprentice for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a>!</p>
        <h3>Next Steps</h3>
        <p>To get things rolling, you can contact #{user.first_name} at #{user.email} or #{user.phone} to set up your first meeting together. If you'd prefer to have us facilitate the first meeting with you and #{user.first_name} at the GirlsGuild HQ, just reply to this email to let us know.</p>
        <p>Make sure to also print copies of:</p>
        <ul>
          <li>the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> - it covers some guidelines for the apprenticeship,</li>
          <li>the <a href="http://girlsguild.com/waivers/ReleaseWaiver-adults.pdf">Participation Waiver</a>,</li>
          <li>and if she's under 19, the <a href="http://girlsguild.com/waivers/IndemnificationAgreement-minors.pdf">Indemnification Agreement for Minors</a>.</li>
        </ul>
        <p>Your apprentice (and for minors, their parents) should sign each of these before you begin work!</p>
        <p>You can also check out our <a href="http://girlsguild.com/handbook/GirlsGuildHandbook.pdf">Apprenticeship Handbook</a> for ideas on how to get the most out of your apprenticeship experience.</p>
        <h3>Payment and Cancellation</h3>
        <p>In case she can't take on the commitment, #{user.first_name} still has 7 days to cancel her application. If we don't hear from her within a week, we'll assume you've already begun working together and go ahead and confirm the apprenticeship by charging your credit card. If you need to update your billing information before then, you can do so <a href="#{billing_url}">here</a>.</p>
        <h3>Questions or Feedback?</h3>
        <p>If you have any questions or feedback, just respond to this email - we're here to support you throughout the apprenticeship!</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_accept_maker_daughter(opts={})
    Pony.mail({
      :to => "#{event.user.first_name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You've accepted #{self.daughter_firstname} as your apprentice!",
      :html_body => %(<h1>Hoorah!</h1>
        <p>You've accepted #{self.daughter_firstname} as your apprentice for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a>!</p>
        <h3>Next Steps</h3>
        <p>To get things rolling, you can contact her parent, #{user.first_name}, at #{user.email} or #{user.phone} to set up your first meeting together. If you'd prefer to have us facilitate the first meeting with you, #{self.daughter_firstname} and #{user.first_name} at the GirlsGuild HQ, just reply to this email to let us know.</p>
        <p>Make sure to also print copies of:</p>
        <ul>
          <li>the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> - it covers some guidelines for the apprenticeship,</li>
          <li>the <a href="http://girlsguild.com/waivers/ReleaseWaiver-adults.pdf">Participation Waiver</a>,</li>
          <li>and if she's under 19, the <a href="http://girlsguild.com/waivers/IndemnificationAgreement-minors.pdf">Indemnification Agreement for Minors</a>.</li>
        </ul>
        <p>Your apprentice and her parent should sign each of these before you begin work!</p>
        <p>You can also check out our <a href="http://girlsguild.com/handbook/GirlsGuildHandbook.pdf">Apprenticeship Handbook</a> for ideas on how to get the most out of your apprenticeship experience.</p>
        <h3>Payment and Cancellation</h3>
        <p>In case she can't take on the commitment, #{user.first_name} still has 7 days to cancel the application. If we don't hear from her within a week, we'll assume you and #{self.daughter_firstname} have already begun working together, and go ahead and confirm the apprenticeship by charging your credit card. If you need to update your billing information before then, you can do so <a href="#{billing_url}">here</a>.</p>
        <h3>Questions or Feedback?</h3>
        <p>If you have any questions feel free to respond to this email.</p>
        <p>~<br/>Thanks,</br>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_confirm_auto(opts={})
    if self.parent?
      deliver_confirm_parent_auto(opts)
    elsif self.minor?
      deliver_confirm_minor_auto(opts)
    else
      deliver_confirm_self_auto(opts)
    end
  end

  def deliver_confirm_self_auto(opts={})
    return false unless valid?
    payment = opts[:payment]
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship is good to go! - #{self.event.title}",
      :html_body => %(<h1>Yesss!</h1>
        <p>You're all set for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a>! We have charged the card on file for your payment of $30.</p>
        <p>If you haven't yet, you can get in touch with #{self.event.user.name} by email at #{self.event.user.email} to plan your first meeting together. Don't forget to download and print the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> to set out some guidelines together.</p>
        <p>Keep in mind these tips for having a great apprenticeship:</p>
        <ul>
          <li><strong>Get Dirty</strong> - Roll up your sleeves! You should be learning new things frequently enough to stay challenged, but don't be afraid to practice what you're learning; you're there to both learn and be helpful!</li>
          <li><strong>Be Curious</strong> - Ask what it's like to run a small business, how she got to where she is in her field, and the challenges she's had along the way - it's likely that you've experienced some of the same stuff.</li>
          <li><strong>Ask for Feedback</strong> - Remember to ask for gentle but constructive feedback. You'll gain the best kind of real-life experience when you're learning from your mistakes.</li>
          <li><strong>Share Goals</strong> - Get to know each others goals and dreams! We want to help you build a mentor network because we're all stronger when we learn together.</li>
        </ul>
        <p>We'll follow up in a week or so to see how things are going, but in the meantime if you have any questions or concerns, I (#{self.personal_contact_name}) will be your personal contact throughout the apprenticeship. You can reach me at #{self.personal_contact_email} or by replying to this email. I'm here to help!</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_confirm_minor_auto(opts={})
    return false unless valid?
    payment = opts[:payment]
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship is good to go! - #{self.event.title}",
      :html_body => %(<h1>Yesss!</h1>
        <p>You're all set for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a>! We have charged the card on file for your payment of $30.</p>
        <p>If you haven't yet, you can get in touch with #{self.event.user.name} by email at #{self.event.user.email} to plan your first meeting together. Don't forget to download and print the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> to set out some guidelines together.</p>
        <p>Keep in mind these tips for having a great apprenticeship:</p>
        <ul>
          <li><strong>Get Dirty</strong> - Roll up your sleeves! You should be learning new things frequently enough to stay challenged, but don't be afraid to practice what you're learning; you're there to both learn and be helpful!</li>
          <li><strong>Be Curious</strong> - Ask what it's like to run a small business, how she got to where she is in her field, and the challenges she's had along the way - it's likely that you've experienced some of the same stuff.</li>
          <li><strong>Ask for Feedback</strong> - Remember to ask for gentle but constructive feedback. You'll gain the best kind of real-life experience when you're learning from your mistakes.</li>
          <li><strong>Share Goals</strong> - Get to know each others goals and dreams! We want to help you build a mentor network because we're all stronger when we learn together.</li>
        </ul>
        <p>We'll follow up in a week or so to see how things are going, but in the meantime if you have any questions or concerns, I (#{self.personal_contact_name}) will be your personal contact throughout the apprenticeship. You can reach me at #{self.personal_contact_email} or by replying to this email. I'm here to help!</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :cc => "#{self.parent_name}<#{self.parent_email}>",
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_confirm_parent_auto(opts={})
    return false unless valid?
    payment = opts[:payment]
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship is good to go! - #{self.event.title}",
      :html_body => %(<h1>Yesss!</h1>
        <p>#{self.daughter_firstname} is all set for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a>! We have charged the card on file for your payment of $30.</p>
        <p>If you haven't yet, you can get in touch with #{self.event.user.name} by email at #{self.event.user.email} to plan their first meeting together. Don't forget to download and print the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> to set out some guidelines together.</p>
        <p>Help #{self.daughter_firstname} remember these tips for having a great apprenticeship:</p>
        <ul>
          <li><strong>Get Dirty</strong> - Roll up your sleeves! You should be learning new things frequently enough to stay challenged, but don't be afraid to practice what you're learning; you're there to both learn and be helpful!</li>
          <li><strong>Be Curious</strong> - Ask what it's like to run a small business, how she got to where she is in her field, and the challenges she's had along the way - it's likely that you've experienced some of the same stuff.</li>
          <li><strong>Ask for Feedback</strong> - Remember to ask for gentle but constructive feedback. You'll gain the best kind of real-life experience when you're learning from your mistakes.</li>
          <li><strong>Share Goals</strong> - Get to know each others goals and dreams! We want to help you build a mentor network because we're all stronger when we learn together.</li>
        </ul>
        <p>We'll follow up in a week or so to see how things are going, but in the meantime if you have any questions or concerns, I (#{self.personal_contact_name}) will be your personal contact throughout the apprenticeship. You can reach me at #{self.personal_contact_email} or by replying to this email. I'm here to help!</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_confirm_maker_auto(opts={})
    parent? ? deliver_confirm_maker_parent_auto(opts) : deliver_confirm_maker_girl_auto(opts)
  end

  def deliver_confirm_maker_girl_auto(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship with #{user.first_name} is good to go! - #{self.event.title}",
      :html_body => %(<h1>Yesss!</h1>
        <p>You're all set to work with #{user.first_name} for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a>! We've gone ahead and charged your card the $30 confirmation fee. </p>
        <p>If you haven't yet, you can contact #{user.first_name} at #{user.email} or #{user.phone} to set up your first meeting together.</p>
        <p>Don't forget to bring a copy of:</p>
        <ul>
        <li>the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> to set out some guidelines together,</li>
        <li>the <a href="http://girlsguild.com/waivers/ReleaseWaiver-adults.pdf">Participation Waiver</a>,</li>
        <li>and if she's under 19, the <a href="http://girlsguild.com/waivers/IndemnificationAgreement-minors.pdf">Indemnification Agreement for Minors</a>.</li>
        </ul>
        <p>We'll follow up in a week or so to see how things are going, but in the meantime if you have any questions or concerns, I (#{self.personal_contact_name}) will be your personal contact throughout the apprenticeship. You can reach me at #{self.personal_contact_email} or by replying to this email. I'm here to help!</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_confirm_maker_parent_auto(opts={})
    return false unless valid?
    Pony.mail({
      :to => "#{event.user.name}<#{event.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship with #{self.daughter_firstname} is good to go! - #{self.event.title}",
      :html_body => %(<h1>Yesss! </h1>
        <p>You're all set to work with #{self.daughter_firstname} for <a href="#{apprenticeship_url(self)}"> #{self.event.title}</a>! We've gone ahead and charged your card the $30 confirmation fee. </p>
        <p>If you haven't yet, you can contact her parent, #{user.first_name}, at #{user.email} or #{user.phone} to set up your first meeting with #{self.daughter_firstname}.
        <p>Don't forget to bring a copy of:</p>
        <ul>
        <li>the <a href="http://girlsguild.com/docs/Apprenticeship_Agreement.pdf">Apprenticeship Agreement</a> to set out some guidelines together,</li>
        <li>the <a href="http://girlsguild.com/waivers/ReleaseWaiver-adults.pdf">Participation Waiver</a>,</li>
        <li>the <a href="http://girlsguild.com/waivers/IndemnificationAgreement-minors.pdf">Indemnification Agreement for Minors</a>.</li>
        </ul>
        <p>We'll follow up in a week or so to see how things are going, but in the meantime if you have any questions or concerns, I (#{self.personal_contact_name}) will be your personal contact throughout the apprenticeship. You can reach me at #{self.personal_contact_email} or by replying to this email. I'm here to help!</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_apprentice_payment_failed
    return false unless valid?
    Pony.mail({
      :to => "Diana & Cheyenne<hello@girlsguild.com>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Apprentice payment failed for #{self.event.title}",
      :html_body => %(<h1>Crap</h1>
      <p>#{self.user.first_name}'s payment failed when we tried to confirm the apprenticeship!</p>
      <p>Look into it, dudes.</p>),
    })
    return true
  end

  def deliver_maker_payment_failed
    return false unless valid?
    Pony.mail({
      :to => "Diana & Cheyenne<hello@girlsguild.com>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Maker payment failed for #{self.event.title}",
      :html_body => %(<h1>Crap</h1>
      <p>#{self.event.user.first_name}'s payment failed when #{self.user.first_name} confirmed the apprenticeship!</p>
      <p>Look into it, dudes.</p>),
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
        :html_body => %(<h1>We're excited you'll be working together soon!</h1>
          <p>Just a reminder that your apprenticeship should be starting in a few days. If you've already set up your first meeting, you're good to go! If you haven't connected already, you'll want to get in touch to set up your first meeting - #{self.event.user.email}</p>
          <p>#{user.first_name}, remember to print and sign a copy of the <a href="http://girlsguild.com/waivers/ReleaseWaiver-adults.pdf">Participation Waiver</a> (and if you're under 18, have your parents sign the <a href="http://girlsguild.com/waivers/IndemnificationAgreement-minors.pdf">Indemnification Agreement for Minors</a>) and give it to #{self.event.host_firstname} before you begin work! </p>
          <p>Let us know if you have any questions before you get started!</p>
          <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
        :bcc => "hello@girlsguild.com",
    })
    self.update_column(:app_reminder_sent, true)
    return true
  end

  def deliver_followup
    return false unless valid?
    Pony.mail({
        :to => "#{user.name}<#{user.email}>",
        :from => "Diana & Cheyenne<hello@girlsguild.com>",
        :reply_to => "GirlsGuild<hello@girlsguild.com>",
        :subject => "How's it going? - #{self.event.title}",
        :html_body => %(<h1>Hey #{user.first_name}!</h1>
          <p>We just wanted to check in and see how your apprenticeship is going with #{event.user.first_name}. Do you have any feedback, good or bad, about the process so far? We'd love to hear it.</p>
          <p>We'd be oh so grateful if you'd take a few minutes to answer <a href="http://www.surveymonkey.com/s/TNVMCT6">a quick, anonymous survey</a> about your experience with GirlsGuild.
          <p>And of course, if you have any questions or concerns, don't hesitate to ask! </p>
          <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
        :bcc => "hello@girlsguild.com",
    })
    self.update_column(:app_followup_sent, true)
    return true
  end

  def deliver_followup_maker
    return false unless valid?
    Pony.mail({
        :to => "#{event.user.name}<#{event.user.email}>",
        :from => "Diana & Cheyenne<hello@girlsguild.com>",
        :reply_to => "GirlsGuild<hello@girlsguild.com>",
        :subject => "How's it going with #{user.first_name}?",
        :html_body => %(<h1>Hey #{event.user.first_name}!</h1>
          <p>We just wanted to check in and see how your apprenticeship is going with #{user.first_name}. Do you have any feedback, good or bad, about the process so far? We'd love to hear it.</p>
          <p>We'd be oh so grateful if you'd take a few minutes to answer <a href="http://www.surveymonkey.com/s/ZNVPB8Q">a quick, anonymous survey</a> about your experience with GirlsGuild.
          <p>And of course, if you have any questions or concerns, don't hesitate to ask!</p>
          <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
        :bcc => "hello@girlsguild.com",
    })
    self.update_column(:app_followup_maker_sent, true)
    return true
  end

  def self.auto_confirm_apprenticeship
    date_range = (Date.today-14.days)..(Date.today-7.days)
    AppSignup.where(:updated_at => date_range, :state => "accepted").map.each do |app|
      app.process_auto_payment
    end
  end


  def self.remind_maker_to_review
    # UPDATE: date_range = (Date.today-5.days)..(Date.today+1)
    # UPDATE: Apprenticeship.where(state: "started", help_posting_sent: false, :created_at => date_range).each do |app|
      # UPDATE: app.deliver_help_posting
    # end
  end

  def self.reminder
    date_range = Date.today..(Date.today+3.days)
    AppSignup.joins(:event).where(events: {:begins_at => date_range}).where(state: 'confirmed', app_reminder_sent: false).each do |app|
      app.deliver_reminder
    end
  end

  def self.followup
    date_range = (Date.today-3.days)..Date.today
    AppSignup.joins(:event).where(events: {:begins_at => date_range}).where(state: 'confirmed', app_followup_sent: false).each do |app|
      app.deliver_followup && app.deliver_followup_maker
    end
  end

  def include_decline_reason
    if decline_reason?
      "#{self.event.user.first_name} also asked us to forward along this message:</p> <p style='font-style:italic;'>#{self.decline_reason}"
    else
      ""
    end
  end

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
      # validates_acceptance_of :respect_agreement, :message => "You must agree to respect the artist's style and techniques.", :if => :respect_agreement?
    end

    state :completed do
    end

    event :resubmit do
      transition :canceled => :pending
    end

    event :complete do
      transition :confirmed => :completed
    end
  end

  def state_label
    if self.started?
      return "saved"
    elsif self.confirmed?
      return "going on"
    elsif self.interview_requested? || self.interview_scheduled?
      return "interviewing"
    else
      return self.state
    end
  end

  def countdown_message
    if self.started?
      return "Your application is saved. <a href=#{edit_app_signup_path(self)} class='bold'>Finish applying!</a>".html_safe
    elsif self.pending?
      return "Your application is being reviewed. You should hear back by <strong>#{(self.state_stamps.last.stamp + 14.days).strftime("%b %d")}</strong>".html_safe
    elsif self.interview_requested?
      return "#{self.event.user.first_name} has <a href=#{app_signup_path(self)}>requested an interview.</a>".html_safe
    elsif self.interview_scheduled?
      return "Your interview is scheduled.<br/> <b><a href=#{app_signup_path(self)}>Reschedule,</a></b> or <b><a href=#{app_signup_path(self)}>send a message</a></b>".html_safe
    elsif self.accepted?
      return "Your application has been accepted! <br/> We'll confirm it and process your apprenticeship fee in #{(self.state_stamps.last.stamp + 7.days).mjd - Date.today.mjd} days.".html_safe
    elsif self.declined?
      return "It did't work out, but you're still awesome!"
    elsif self.canceled?
      if self.event.canceled?
        return "This event has been canceled"
      else
        return "Your application has been canceled"
      end
    elsif self.confirmed?
      if self.event.datetime_tba
        return ''
      elsif self.event.begins_at && Date.today < self.event.begins_at
        return "<strong>#{(self.event.begins_at.mjd - Date.today.mjd)}</strong> days until your apprenticeship begins!".html_safe
      elsif self.event.ends_at && Date.today < self.event.ends_at
        return "#{self.event.ends_at.mjd - Date.today.mjd} more days of your Apprenticeship"
      else
        return false
      end
    elsif self.completed?
      return "Your apprenticeship is complete"
    else
    end
    return ''
  end

  def countdown_message_maker
  if self.started?
    elsif self.pending? || self.interview_scheduled? || self.interview_requested?
      return "#{(self.state_stamps.last.stamp + 14.days).mjd - Date.today.mjd} days left to <a href=#{app_signup_path(self)} class='bold'>review</a> ".html_safe
    elsif self.accepted?
      return "#{(self.state_stamps.last.stamp + 7.days).mjd - Date.today.mjd} days until we process your payment.</a> ".html_safe
    elsif self.declined?
    elsif self.canceled?
    elsif self.confirmed?
    elsif self.completed?
    else
    end
    return ''
  end
end
