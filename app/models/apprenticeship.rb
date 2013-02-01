class Apprenticeship < Event

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

	state_machine :state, :initial => :started do

		state :pending do
			validates_presence_of :kind, :hours, :hours_per, :charge_id	
			validates_numericality_of :hours, :greater_than => 0
		end
	end

end