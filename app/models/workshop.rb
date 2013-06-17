class Workshop < Event

	has_many :users, :through => :signup
	has_many :users, :through => :prereg


  validation_group :design do
    validates_presence_of :begins_at_time, :ends_at_time, :registration_max, :price
    validates_numericality_of :price, :greater_than_or_equal_to => 0
    validates_numericality_of :registration_max, :greater_than => :registration_min, :message => "Must be greater than the minimum number of participants."
    validates_numericality_of :age_min, :greater_than => 0
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set."
    validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your workshop to start at least a week from today. Please check the date you set.'}, :if => :tba_is_blank
    validates :ends_at, :date => {:before_or_equal_to => :begins_at, :message => 'You must close registrations prior to the planned date of the workshop.' }, :if => :tba_is_blank
    validate :host_album_limit
  end

  validation_group :begins_at do
    validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your workshop to start at least a week from today. Please check the date you set.'}, :if => :tba_is_blank
  end

  validation_group :begins_at_time do
    validates_presence_of :begins_at_time
  end

  validation_group :ends_at_time do
    validates_presence_of :ends_at_time
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
			:html_body => %(<h1>Hooray #{user.first_name}!</h1> <p>We're thrilled you're building a workshop! If you get stuck take a look at our <a href="http://www.girlsguild.com/faq_makers">FAQ for Makers</a>, or feel free to respond to this email with any questions you might have!</p> <p>You can edit your workshop and add images here - <a href="#{url_for(self)}"> #{self.title}</a></p>),
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
			:html_body => %(<h1>Thanks #{user.first_name}!</h1> <p>Your workshop has been submitted and is pending until you <a href="#{url_for(self)}">upload your images</a>.</p> <p>You can review the submitted workshop and add your images here - <a href="#{url_for(self)}"> #{self.title}</a></p> <p>Please note that you won't be able to edit the details of your workshop until it's been approved, at which point it will need to be approved again.</p>),
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
			:html_body => %(<h1>Nice!</h1> <p>Your workshop is currently pending while we review your changes.</p> <p>You can review the submitted workshop and add your images here - <a href="#{url_for(self)}"> #{self.title}</a></p> <p>Please note that you won't be able to edit the details of your workshop until it's been approved, at which point it will need to be approved again.</p>),
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
			:html_body => %(<h1>Congrats #{user.first_name}!</h1> <p>Your workshop has been posted and is now live! Check it out - <a href="#{url_for(self)}"> #{self.title}</a></p> <p>Be sure to invite your friends and share it on your social networks!</p>),
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
			:html_body => %(<h1>Bummer!</h1> <p>You've canceled your workshop. We hope you'll consider offering it again sometime!</p> <p>You can edit the workshop and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a></p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
		#Can we enter another email into this method, like:
		#return false unless valid?
		#Pony.mail({
		#	:to => the list of people signed up for the workshop
   	#	:from => "Diana & Cheyenne<hello@girlsguild.com>",
		#	:reply_to => "GirlsGuild<hello@girlsguild.com>",
		#	:subject => "Your workshop has been canceled - #{topic} with #{user.name}",
		#	:html_body => %(Bummer! <br/><br/>We're sorry to say the #{topic} workshop with #{user.name} has been cancelled. It may be rescheduled later, and if it is you'll be the first to know! In the meantime we'll refund your sign-up fee, and you can check out other upcoming workshops you might like here: <a href="#{url_for(workshops)}"> #{workshops_path}</a>),
		#	:bcc => "hello@girlsguild.com",
		#})
		#return true
	end

	def deliver_reject
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been rejected - #{topic} with #{user.name}",
			:html_body => %(<h1>Perp-Alert!</h1> <p>We've rejected your workshop cause you're a creeper (Insert our actual reason here). We hope you'll consider offering it again sometime!</p> <p>You can edit the workshop and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a></p>),
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
			:html_body => %(<h1>Noooooo!</h1> <p>We've rejected your workshop for some reason... (Insert our actual reason here). We hope you'll consider offering it again sometime!</p> <p>You can edit the workshop and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a></p>),
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
        <p>So far, #{self.signups.where(:state => 'confirmed').count} people have signed up, and registration closes on #{self.ends_at}. We'll let you know if anyone new signs up before then.</p>),
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
      :html_body => %(<h1>Hey #{user.first_name}!</h1> <p>How did your workshop go? We'd love to hear your feedback on the teaching experience. (Fill out this email with more info)</p>),
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
			w.cancel! unless w.min_capacity_met?
		end
	end

  def self.maker_reminder
    Workshop.where(:state => ["accepted", "filled"]).where('begins_at >= ?', 3.days).where(:reminder_sent => false).each do |work|
      work.deliver_maker_reminder
    end
  end

  def self.maker_followup
    Workshop.where(:state => 'completed').where('begins_at <= ?', 3.days.ago).where(:follow_up_sent => false).each do |work|
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

  def countdown_message
    if self.started?
      return ''

    elsif self.pending?
      return "GirlsGuild is lookin it over."

    elsif self.accepted?
      if !self.confirmed_signups.empty?
        if self.datetime_tba
          return "#{self.confirmed_signups.count} of #{self.registration_max} participants confirmed."
        elsif self.begins_at && Date.today < self.begins_at
          return "#{self.confirmed_signups.count} of #{self.registration_max} participants confirmed.<br/><strong>#{(self.ends_at.mjd - Date.today.mjd)}</strong> days for people to sign up.".html_safe
        else
          return ''
        end
      else
        return "Open for Applications"
      end
    elsif self.canceled?
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