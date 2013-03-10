class Apprenticeship < Event

	validates_presence_of :kind, :hours, :hours_per #, :charge_id (shouldn't need this bc we added 'update_attribute(:charge_id, charge.id)' to process_payment method)
	validates_numericality_of :hours, :greater_than => 0
	validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your apprenticeship to start at least a week from today. Please check the dates you set.'}, :if => :tba_is_blank
	validates :ends_at, :date => {:after => :begins_at, :message => "Oops! Please check the dates you set. Your apprenticeship can't end before it begins!"}, :if => :tba_is_blank

	def default_url_options
	  { :host => 'localhost:3000'}
	end

	def deliver_save
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      		:from => "GirlsGuild<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been saved - #{topic} with #{user.name}",
			:html_body => %(<h1>Word!</h1> <p>We're thrilled you're building an apprenticeship! If you get stuck take a look at our <a href="http://www.girlsguild.com/faq">FAQ</a>, or feel free to respond to this email with any questions you might have!</p> <p>You can edit your apprenticeship and add images here - <a href="#{url_for(self)}"> #{self.title}</a></p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      		:from => "GirlsGuild<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been submitted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Thanks!</h1> <p>Your apprenticeship has been submitted and is pending until you <a href="#{url_for(self)}">upload your images</a>.</p> <p>You can review the submitted apprenticeship and add your images here - <a href="#{url_for(self)}"> #{self.title}</a></p><p>Please note that you won't be able to edit the details of your apprenticeship until it's been approved, at which point it will need to be approved again.),
			:bcc => "hello@girlsguild.com",
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
			:html_body => %(<h1>Nice!</h1> <p>Your apprenticeship is currently pending while we review your changes.</p> <p>You can review the submitted apprenticeship and add your images here - <a href="#{url_for(self)}"> #{self.title}</a></p> <p>Please note that you won't be able to edit the details of your apprenticeship until it's been approved, at which point it will need to be approved again.),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_accept
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      		:from => "GirlsGuild<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been posted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Congrats!</h1> <p>Your apprenticeship has been posted and is now live! Check it out - <a href="#{url_for(self)}"> #{self.title}</a></p> <p>Be sure to invite your friends and share it on your social networks!</p>),
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
		#
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
	    apprenticeships = self.where(:ends_at => Date.today).all
		apprenticeships.each {|a| a.complete}
	end

	state_machine :state, :initial => :started do
		event :complete do
        	transition :accepted => :completed #once signup is working this should be :in_progress => :completed
        end
	end
end