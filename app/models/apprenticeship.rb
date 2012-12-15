class Apprenticeship < Event

	def generate_title
  		self.title = "#{self.topic} Apprenticeship with #{self.host}"
	end

end