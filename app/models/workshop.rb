class Workshop < Event
include EventHelper

	has_many :users, :through => :signup
	has_many :users, :through => :prereg


  validation_group :design do
    validates_presence_of :begins_at_time, :ends_at_time, :if => :tba_is_blank
    validates_presence_of :registration_max, :price
    validates_numericality_of :price, :greater_than_or_equal_to => 0
    validates_numericality_of :registration_max, :greater_than => :registration_min, :message => "Must be greater than the minimum number of participants."
    validates_numericality_of :age_min, :greater_than => 0
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set."
    validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your workshop to start at least a week from today. Please check the date you set.'}, :if => :tba_is_blank
    validates :ends_at, :date => {:before_or_equal_to => :begins_at, :message => 'You must close registrations prior to the planned date of the workshop.' }, :date => { :before => Date.today, :message => 'Oops! The date you chose to close registrations is in the past! Please check the date you set.' }, :if => :tba_is_blank
    validate :host_album_limit
  end

  validation_group :begins_at do
    validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your workshop to start at least a week from today. Please check the date you set.'}, :if => :tba_is_blank
  end

  validation_group :begins_at_time do
    validates_presence_of :begins_at_time, :if => :tba_is_blank
  end

  validation_group :ends_at_time do
    validates_presence_of :ends_at_time, :if => :tba_is_blank
  end

  validation_group :ends_at do
    validates :ends_at, :date => {:before_or_equal_to => :begins_at, :message => 'You must close registrations prior to the planned date of the workshop.' }, :if => :tba_is_blank
  end

  validation_group :age_min do
    validates_numericality_of :age_min, :greater_than => 0
  end

  validation_group :age_max do
    validates_numericality_of :age_max, :greater_than => :age_min, :message => "Must be greater than the minimum age."
  end

  validation_group :registration_max do
    validates_presence_of :registration_max
    validates_numericality_of :registration_max
    validates_numericality_of :registration_max, :greater_than => :registration_min, :message => "Must be greater than the minimum number of participants."
  end

  validation_group :price do
    validates_presence_of :price
    validates_numericality_of :price, :greater_than_or_equal_to => 0
  end


  validation_group :private do
    validates_presence_of :payment_options, :permission
  end

 include Emailable

	def deliver_save
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been saved - #{topic} with #{user.name}",
			:html_body => %(<h1>Hooray #{user.first_name}!</h1>
        <p>We're thrilled you're building a workshop! If you get stuck take a look at our <a href="#{faq_makers_url}">FAQ for Makers</a>, or feel free to respond to this email with any questions you might have!</p>
        <p>You can edit your workshop here - <a href="#{url_for(self)}"> #{self.title}</a> or monitor it from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Thanks,</p>
        <p>The GirlsGuild Team</p>),
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
			:subject => "Your workshop has been submitted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Thanks #{user.first_name}!</h1>
        <p>Your workshop has been submitted and is pending while we take a look at it.</p>
        <p>You can review the submitted workshop here - <a href="#{url_for(self)}"> #{self.title}</a> or monitor it from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Please note that you won't be able to edit the details of your workshop until it's been approved. Then if you make changes, we'll need to review it again.</p>
        <p>While you wait, go ahead and fill out your profile in your <a href="#{edit_user_registration_url(user)}">Settings Dashboard</a> like your bio, and links to your website, twitter, and facebook if you're into the social thing.</p>
        <p>Thanks,</p>
        <p>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_resubmit
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been resubmitted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Nice!</h1>
        <p>Your workshop is currently pending while we take a look at your changes.</p>
        <p>You can review the updated workshop here - <a href="#{url_for(self)}"> #{self.title}</a> or monitor it from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Just like last time, you won't be able to edit the details of your workshop until it's been approved, at which point any edits will need to be reviewed again.</p>
        <p>Thanks,</p>
        <p>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_accept
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been posted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Congrats #{user.first_name}!</h1>
        <p>Your workshop has been posted and is now live! Check it out - <a href="#{url_for(self)}"> #{self.title}</a></p>
        <p>Be sure to invite your friends and share it on your social networks!</p>
        <p>If it's posted as TBA we'll email you as people follow it, so you can decide when to set the date. If you already set a date, we'll let you know whenever someone signs up. Registrations will be closed when #{self.registration_max} people have signed up or on the date you set. </p>
        <p>If by some bad luck you need to cancel your workshop, you can do so from your <a href="#{dashboard_url}">Events Dashboard</a>. Likewise, if it turns out fewer than your minimum #{self.registration_min} participants sign up, the workshop will automatically be canceled on #{get_formated_date(self.ends_at, format: "%b %e, %Y")}. We think it's going to rock, though!</p>
        <p>Let us know if you have any questions!</p>
        <p>Thanks and Happy Making!</p>
        <p>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_cancel
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been canceled - #{topic} with #{user.name}",
			:html_body => %(<h1>Bummer!</h1>
        <p>You've canceled your workshop. We hope you'll consider offering it again sometime!</p>
        <p>You can edit the workshop and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Thanks,</p>
        <p>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

  def deliver_cancel_applicants
    Pony.mail({
      :to => "#{self.signup.user.name}<#{self.signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Workshop has been canceled - #{topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>We're sorry to say that #{user.name} has had to cancel her workshop on #{self.topic}. It may be rescheduled later, and if it is you'll be the first to know!</p>
        <p>In the meantime we'll refund your sign-up fee, and you can check out other upcoming workshops you might like here: <a href="#{url_for(workshops)}"> #{workshops_path}</a>.</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

	def deliver_reject
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "We couldn't post your workshop - #{topic} with #{user.name}",
			:html_body => %(<h1>Sorry.</h1>
        <p>We can't post your workshop because there was a problem with your submission:</p>
        <p><i>#{self.reject_reason}</i></p>
        <p>If the problem is with the formatting or content of the workshop, you can edit and resubmit it anytime. Find it here - <a href="#{edit_workshop_url(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Please let us know if you have any questions.</p>
        <p>Thanks,</p>
        <p>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_revoke
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been revoked - #{topic} with #{user.name}",
			:html_body => %(<h1>Sorry.</h1>
        <p>We've had to take down your workshop because of an issue:</p>
        <p><i>#{self.revoke_reason}</i></p>
        <p>If the problem is with the formatting or content of the workshop, you can edit and resubmit it anytime. Find it here - <a href="#{edit_workshop_url(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Please let us know if you have any questions.</p>
        <p>Thanks,</p>
        <p>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
  end

  def deliver_maker_reminder
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop is coming up! - #{self.title}",
      :html_body => %(<h1>3, 2, 1... it's almost time!</h1>
        <p>Just a reminder that your workshop is happening on #{self.begins_at}.</p>
        <p>So far, #{self.signups.where(:state => 'confirmed').count} people have signed up, and registration closes on #{get_formated_date(self.ends_at, format: "%b %e, %Y")}. We'll let you know if anyone new signs up before then! You can also view who has signed up from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Thanks and Happy Making!</p>
        <p>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:reminder_sent, true)
    return true
  end

  def deliver_maker_followup
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "How was your workshop? - #{self.title}",
      :html_body => %(<h1>Hey #{user.first_name}!</h1>
        <p>How did your workshop go? We'd love to hear about it.</p>
        <p>Do you have any feedback, good or bad, on the process of posting and leading your workshop, or suggestions on what we can do to make it easier? We want to know what you think.</p>
        <p>We hope it was a great experience, and want to make it even better next time.</p>
        <p>Thanks,</p>
        <p>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:follow_up_sent, true)
    return true
  end

	def self.complete_workshop
    Workshop.where('begins_at <= ?', Date.today).all.each do |workshop|
      workshop.signups.each {|w| w.complete}
      workshop.complete
    end
	end

	def self.cancel_workshop
    #Note: ends_at is the registration close date on workshops
		workshops = Workshop.where('ends_at <= ?', Date.today).all
		workshops.each do |w|
			w.cancel unless w.min_capacity_met?
		end
	end

  def self.maker_reminder
    date_range = Date.today..(Date.today+3.days)
    Workshop.where(begins_at: date_range, :state => ["accepted", "filled"], reminder_sent: false).each do |work|
      work.deliver_maker_reminder
    end
  end

  def self.maker_followup
    date_range = (Date.today-3.days)..Date.today
    Workshop.where(begins_at: date_range, state: "completed", follow_up_sent: false).each do |work|
      work.deliver_maker_followup
    end
  end

  def total_price
    unless self.price
      return '___'
    end
    return (self.price*1.2).round.to_s
  end

  def checkmarks
    checkmarks = {}
    checkmarks[:design] = self.group_valid?(:design)
    checkmarks[:private] = self.group_valid?(:private)
    self.errors.clear
    return checkmarks
  end

  def state_label
    if self.started?
      return "saved"
    elsif self.accepted?
      return "posted"
    else
      return self.state
    end
  end

  def countdown_message
    if self.started?
      return "Your workshop is saved"

    elsif self.pending?
      return "GirlsGuild is lookin it over"

    elsif self.accepted?
      if !self.confirmed_signups.empty?
        if self.datetime_tba
          return "Posted as TBA, set a date when you're ready"
        elsif self.begins_at && Date.today < self.begins_at
          return "#{self.confirmed_signups.count} of #{self.registration_max} participants confirmed.<br/><strong>#{(self.ends_at.mjd - Date.today.mjd)}</strong> days for people to sign up.".html_safe
        else
          return "Passed"
        end
      else
        return "Open to Follow"
      end
    elsif self.canceled?
      return "You've canceled this workshop"
    elsif self.filled?
      if self.datetime_tba
        return "Workshop"
      elsif self.begins_at && Date.today < self.begins_at
        return "<strong>#{(self.begins_at.mjd - Date.today.mjd)}</strong> days until the Workshop!".html_safe
      else
        return ''
      end
    elsif self.in_progress?
    elsif self.completed?
    end
    return ''
  end

	state_machine :state, :initial => :started do
		event :complete do
      transition :all => :completed
    end

    event :submit do
      transition :started => :pending
    end
	end
end