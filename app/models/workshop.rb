class Workshop < Event

	def generate_title
		self.title = "#{self.topic} Workshop with #{self.host}"
	end

	state_machine :state, :initial => :started do

		state :pending do
			validates_presence_of :begins_at_time, :ends_at_time, :ends_at, :registration_max, :price
			validates_numericality_of :price, :greater_than_or_equal_to => 0
			validates_numericality_of :registration_max, :greater_than => :registration_min, :message => "must be greater than the minimum number of participants."	
		end
	end

end