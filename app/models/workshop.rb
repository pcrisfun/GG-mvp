class Workshop < Event

	has_many :users, :through => :signup

	validates_presence_of :payment_options, :begins_at_time, :ends_at_time, :ends_at, :registration_max, :price
	validates_numericality_of :price, :greater_than_or_equal_to => 0
	validates_numericality_of :registration_max, :greater_than => :registration_min, :message => "must be greater than the minimum number of participants."
	validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your workshop to start at least a week from today. Please check the date you set.'}, :if => :tba_is_blank

	def default_url_options
	  { :host => 'localhost:3000'}
	end

	def deliver_save
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been saved - #{topic} with #{user.name}",
			:html_body => %(<h1>Word!</h1> <p>We're thrilled you're building a workshop! If you get stuck take a look at our <a href="http://www.girlsguild.com/faq">FAQ</a>, or feel free to respond to this email with any questions you might have!</p> <p>You can edit your workshop and add images here - <a href="#{url_for(self)}"> #{self.title}</a></p>),
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
			:html_body => %(<h1>Thanks!</h1> <p>Your workshop has been submitted and is pending until you <a href="#{url_for(self)}">upload your images</a>.</p> <p>You can review the submitted workshop and add your images here - <a href="#{url_for(self)}"> #{self.title}</a></p> <p>Please note that you won't be able to edit the details of your workshop until it's been approved, at which point it will need to be approved again.</p>),
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
			:html_body => %(<h1>Congrats!</h1> <p>Your workshop has been posted and is now live! Check it out - <a href="#{url_for(self)}"> #{self.title}</a></p> <p>Be sure to invite your friends and share it on your social networks!</p>),
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

	def self.complete_workshop
    Workshop.where('begins_at <= ?', Date.today).all.each do |workshop|
      workshop.signups.each {|w| w.complete}
      workshop.complete
    end
	end

	def self.cancel_workshop
		workshops = Workshop.where('ends_at <= ?', Date.today).all
		workshops.each do |w|
			w.cancel! unless w.min_capacity_met?
		end
	end

	state_machine :state, :initial => :started do
		event :complete do
      transition :accepted => :completed
    end
	end
end