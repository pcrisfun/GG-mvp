class Apprenticeship < Event

	def generate_title
   		self.title = "#{self.topic} Apprenticeship with #{self.host_firstname} #{self.host_lastname}"
	end

	state_machine :state, :initial => :started do

		state :pending do
			validates_presence_of :kind, :hours, :hours_per, :charge_id	
			validates_numericality_of :hours, :greater_than => 0
		end
	end

end