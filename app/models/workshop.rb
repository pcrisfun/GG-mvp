class Workshop < Event

	def generate_title
			self.title = "#{self.topic} Workshop with #{self.host}"
	end


	state_machine :state, :initial => :started do
	  	
	  	state :pending do
			validates_numericality_of :price, :greater_than_or_equal_to => 0
			validates_numericality_of :registration_min,  :greater_than_or_equal_to => 0			
	  	end
	 end
end