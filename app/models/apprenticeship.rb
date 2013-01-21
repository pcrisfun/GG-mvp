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

	state_machine :state, :initial => :started do

		state :pending do
			validates_presence_of :kind, :hours, :hours_per, :charge_id	
			validates_numericality_of :hours, :greater_than => 0
		end
	end

end