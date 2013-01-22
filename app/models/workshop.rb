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

	state_machine :state, :initial => :started do

		state :pending do
			validates_presence_of :payment_options, :begins_at_time, :ends_at_time, :ends_at, :registration_max, :price
			validates_numericality_of :price, :greater_than_or_equal_to => 0
			validates_numericality_of :registration_max, :greater_than => :registration_min, :message => "must be greater than the minimum number of participants."	
		end
	end
end