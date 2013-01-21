class Workshop < Event

<<<<<<< HEAD
	def default_url_options
	  { :host => 'localhost:3000'}
	end
=======
  def default_url_options
    { :host => 'http://gg-mvp.dev/' }
  end
>>>>>>> 432b8a7a30a9147a6edb4a0e3f677412479c2cb7

	def generate_title
		self.title = "#{self.topic} Workshop with #{self.host_firstname} #{self.host_lastname}"
	end
<<<<<<< HEAD
	
	def deliver
		return false unless valid?
		Pony.mail({
			:from => %("#{user.name}" <#{user.email}>),
			:reply_to => %("#{user.name}" <#{user.email}>),
			:subject => "New Workshop Proposal - #{topic} with #{user.name}",
			:html_body => %(Review it here - <a href="#{url_for(self)}"> #{self.title}</a>),
=======


	def deliver
		return false unless valid?
		Pony.mail({
			:from => %("#{user.first_name} #{user.last_name}" <#{user.email}>),
			:reply_to => user.email,
			:subject => "#{topic} Workshop with #{host_firstname} #{host_lastname}",
			:body => %(<a href="#{url_for(self)}">#{self.title}</a>),
>>>>>>> 432b8a7a30a9147a6edb4a0e3f677412479c2cb7
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