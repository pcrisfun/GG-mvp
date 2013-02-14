class Workshop < Event

	def default_url_options
	  { :host => 'localhost:3000'}
	end

	def generate_title
		self.title = "#{self.topic} Workshop with #{self.host_firstname} #{self.host_lastname}"
	end
	
	def deliver
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>", 
      		:from => "GirlsGuild<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been submitted! - #{topic} with #{user.name}",
			:html_body => %(Congrats! <br/><br/>Your workshop is currently pending until you <a href="#{url_for(self)}">submit your images</a>. You can review the workshop and add your images here - <a href="#{url_for(self)}"> #{self.title}</a>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_resubmit
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>", 
      		:from => "GirlsGuild<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been resubmitted! - #{topic} with #{user.name}",
			:html_body => %(Thanks! <br/><br/>Your workshop is currently pending while we review your changes. You can review the workshop and add your images here - <a href="#{url_for(self)}"> #{self.title}</a>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_cancel
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>", 
      		:from => "GirlsGuild<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been canceled - #{topic} with #{user.name}",
			:html_body => %(Bummer! <br/><br/>You've canceled your workshop. We hope you'll consider offering it again sometime! You can edit the workshop and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a>),
			:bcc => "hello@girlsguild.com",
		})
		return true
		#Can we enter another email into this method, like:
		#return false unless valid?
		#Pony.mail({
		#	:to => the list of people signed up for the workshop 
      	#	:from => "GirlsGuild<hello@girlsguild.com>",
		#	:reply_to => "GirlsGuild<hello@girlsguild.com>",
		#	:subject => "Your workshop has been canceled - #{topic} with #{user.name}",
		#	:html_body => %(Bummer! <br/><br/>We're sorry to say the #{topic} workshop with #{user.name} has been cancelled. It may be rescheduled later, and if it is you'll be the first to know! In the meantime we'll refund your sign-up fee, and you can check out other upcoming workshops you might like here: <a href="#{url_for(workshops)}"> #{workshops_path}</a>),
		#	:bcc => "hello@girlsguild.com",
		#})
		#return true
	end

	def self.complete_workshop
		workshops = self.where(:begins_at => Date.today).all 
		workshops.each {|w| w.complete}

		#review Date syntax to go in where statment
		#in rails c Workshop.where lablabhakj

	end


	state_machine :state, :initial => :started do

		state :pending do
			validates_presence_of :payment_options, :begins_at_time, :ends_at_time, :ends_at, :registration_max, :price
			validates_numericality_of :price, :greater_than_or_equal_to => 0
			validates_numericality_of :registration_max, :greater_than => :registration_min, :message => "must be greater than the minimum number of participants."	
			validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your workshop to start at least a week from today. Please check the date you set.'}, :if => :tba_is_blank 
		end
	end
end