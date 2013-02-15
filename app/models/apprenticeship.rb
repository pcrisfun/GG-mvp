class Apprenticeship < Event

	validates_presence_of :kind, :hours, :hours_per #, :charge_id	
	validates_numericality_of :hours, :greater_than => 0
	validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your apprenticeship to start at least a week from today. Please check the dates you set.'}, :if => :tba_is_blank 
	validates :ends_at, :date => {:after => :begins_at, :message => "Oops! Please check the dates you set. Your apprenticeship can't end before it begins!"}, :if => :tba_is_blank

	def default_url_options
	  { :host => 'localhost:3000'}
	end

	def generate_title
   		self.title = "#{self.topic} Apprenticeship with #{self.host_firstname} #{self.host_lastname}"
	end

	def deliver
		return false unless valid?
		Pony.mail({
			:from => %("#{user.name}" <#{user.email}>),
			:reply_to => %("#{user.name}" <#{user.email}>),
			:subject => "New Apprenticeship Proposal - #{topic} with #{user.name}",
			:html_body => %(Review it here - <a href="#{url_for(self)}"> #{self.title}</a>),
		})
		return true
	end

	def deliver_resubmit
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>", 
      		:from => "GirlsGuild<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been resubmitted! - #{topic} with #{user.name}",
			:html_body => %(Thanks! <br/><br/>Your apprenticeship is currently pending while we review your changes. You can review the apprenticeship and add your images here - <a href="#{url_for(self)}"> #{self.title}</a>),
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
			:subject => "Your apprenticeship has been canceled - #{topic} with #{user.name}",
			:html_body => %(Bummer! <br/><br/>You've canceled your apprenticeship. We hope you'll consider offering it again sometime! You can edit the apprenticeship and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a>),
			:bcc => "hello@girlsguild.com",
		})
		return true
		#Can we enter another email into this method, like:
		#return false unless valid?
		#Pony.mail({
		#	:to => the list of people signed up for the apprenticeship 
      	#	:from => "GirlsGuild<hello@girlsguild.com>",
		#	:reply_to => "GirlsGuild<hello@girlsguild.com>",
		#	:subject => "Your apprenticeship has been canceled - #{topic} with #{user.name}",
		#	:html_body => %(Bummer! <br/><br/>We're sorry to say the #{topic} apprenticeship with #{user.name} has been cancelled. It may be rescheduled later, and if it is you'll be the first to know! In the meantime we'll refund your sign-up fee, and you can check out other upcoming apprenticehsips you might like here: <a href="#{url_for(apprenticeships)}"> #{apprenticeships_path}</a>),
		#	:bcc => "hello@girlsguild.com",
		#})
		#return true
	end

	def self.complete_apprenticeship
	    puts "fuck yeah."
	end

end