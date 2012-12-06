class Workshop < Event

	def generate_title
  		self.title = "#{self.topic} Workshop with #{self.host}"
	end

end