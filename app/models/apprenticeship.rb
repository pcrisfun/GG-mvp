class Apprenticeship < Event

	has_many :users, :through => :signup
	has_many :users, :through => :prereg

	# validates_presence_of :kind, :hours, :hours_per #, :charge_id (shouldn't need this bc we added 'update_attribute(:charge_id, charge.id)' to process_payment method)
	# validates_numericality_of :hours, :greater_than => 0
	# validates :begins_at, :date => {:after => Proc.new { Date.today + 6.day }, :message => 'Sorry! You need to plan your apprenticeship to start at least a week from today. Please check the dates you set.'}, :if => :tba_is_blank
	# validates :ends_at, :date => {:after => :begins_at, :message => "Oops! Please check the dates you set. Your apprenticeship can't end before it begins!"}, :if => :tba_is_blank
  validation_group :design do
    validates_presence_of :topic
    validates_presence_of :host_firstname
    validates_presence_of :host_lastname
    validates_presence_of :kind
    validates_presence_of :description
    validates_presence_of :availability
    validates_presence_of :begins_at
    validates_presence_of :skill_list
    validates_presence_of :tool_list
    validates_presence_of :location_address
    validates_presence_of :location_city
    validates_presence_of :location_state
    validates_presence_of :location_zipcode
    validates_presence_of :age_min
    validates_presence_of :age_max
    validates_presence_of :registration_max
    validates_numericality_of :age_min, :greater_than => 0
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set."
    validates_numericality_of :registration_max, :greater_than_or_equal_to => 1, :message => " registrations must be greater than 0."
    validate :host_album_limit
  end

  validation_group :private do
    validates_presence_of :permission
  end
  validation_group :topic do
    validates_presence_of :topic
  end
  validation_group :host_firstname do
    validates_presence_of :host_firstname
  end
  validation_group :host_lastname do
    validates_presence_of :host_lastname
  end
  validation_group :kind do
    validates_presence_of :kind
  end
  validation_group :description do
    validates_presence_of :description
  end
  validation_group :availability do
    validates_presence_of :availability
  end
  validation_group :begins_at do
    validates_presence_of :begins_at
  end
  validation_group :skill_list do
    validates_presence_of :skill_list
  end
  validation_group :tool_list do
    validates_presence_of :tool_list
  end
  validation_group :location_address do
    validates_presence_of :location_address
  end
  validation_group :location_city do
    validates_presence_of :location_city
  end
  validation_group :location_state do
    validates_presence_of :location_state
  end
  validation_group :location_zipcode do
    validates_presence_of :location_zipcode
  end
  validation_group :age_min do
    validates_presence_of :age_min
    validates_numericality_of :age_min, :greater_than => 0
  end
  validation_group :age_max do
    validates_presence_of :age_max
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set."
  end
  validation_group :registration_max do
    validates_presence_of :registration_max
    validates_numericality_of :registration_max, :greater_than_or_equal_to => 1, :message => " registrations must be greater than 0."
  end

  include Emailable

	def deliver_save
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "You started building an apprenticeship!",
			:html_body => %(<h1>Hooray #{user.first_name}!</h1>
        <p>We're thrilled you're building an apprenticeship! If you get stuck take a look at our <a href="http://www.girlsguild.com/faq_makers">FAQ for Makers</a>, or feel free to respond to this email with any questions you might have!</p>
        <p>You can <a href="#{edit_apprenticeship_url(self)}">edit your apprenticeship here</a></p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver(opts={})
		return false unless valid?
    payment = opts[:payment]
    Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been submitted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Thanks #{user.first_name}!</h1>
        <p>Your apprenticeship has been submitted and is pending while we take a look at it.</p>
        <p>You can review the submitted apprenticeship here - <a href="#{apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>Please note that you won't be able to edit the details of your apprenticeship until it's been approved. Then if you make changes, we'll need to review it again.</p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_resubmit
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been resubmitted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Nice!</h1>
        <p>Your apprenticeship is currently pending while we take a look at your changes.</p>
        <p>You can review the submitted apprenticeship here - <a href="#{apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>Just like last time, you won't be able to edit the details of your apprenticeship until it's been approved, at which point any edits will need to be reviewed again.</p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_accept
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been posted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Congrats #{user.first_name}!</h1>
        <p>Your apprenticeship has been posted and is now live! Check it out - <a href="#{apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>Be sure to invite your friends and share it on your social networks!</p>
        <p>We'll let you know whenever someone applies. Applications will be closed when you've accepted #{self.registration_max} apprentices.</p>
        <p>If by some bad luck you need to cancel your apprenticeship, you can do so from <a href="#{url_for(dashboard_path)}">your dashboard</a> - but we're crossing our fingers that won't happen!</p>
        <p>Let us know if you have any questions!</p>
        <p>Thanks and Happy Making!</p>
        <p>the GirlsGuild team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_cancel
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been canceled - #{topic} with #{user.name}",
			:html_body => %(<h1>Bummer!</h1>
        <p>You've canceled your apprenticeship. We hope you'll consider offering it again sometime!</p>
        <p>You can edit the apprenticeship and resubmit it anytime. Find it here - <a href="#{edit_apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

  #def deliver_cancel_applicants
   # Pony.mail({
    #  :to => "#{self.app_signups.where(:state => ['pending', 'accepted']).each do |app|}",
    # :from => "Cheyenne & Diana<hello@girlsguild.com>",
    # :reply_to => "GirlsGuild<hello@girlsguild.com>",
    # :subject => "Your apprenticeship has been canceled - #{topic} with #{user.name}",
    # :html_body => %(Bummer! <br/><br/>We're sorry to say the #{topic} apprenticeship with #{user.name} has been cancelled. It may be rescheduled later, and if it is you'll be the first to know! In the meantime we'll refund your sign-up fee, and you can check out other upcoming apprenticehsips you might like here: <a href="#{url_for(apprenticeships)}"> #{apprenticeships_path}</a>),
    # :bcc => "hello@girlsguild.com",
   # })
   # return true
  #end

	def deliver_reject
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "We couldn't post your apprenticeship - #{topic} with #{user.name}",
			:html_body => %(<h1>Sorry.</h1>
        <p>We can't post your apprenticeship because there was a problem with your submission:</p>
        <p>[pull in reject_reason here].</p>
        <p>If the problem is with the formatting or content of the apprenticeship, you can edit and resubmit it anytime. Find it here - <a href="#{edit_apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>Please let us know if you have any questions.</p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_revoke
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
   		:from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your apprenticeship has been revoked - #{topic} with #{user.name}",
			:html_body => %(<h1>Sorry.</h1>
        <p>We've had to revoke your apprenticeship because of an issue:</p>
        <p>[pull in revoke_reason here].</p>
        <p>If the problem is with the formatting or content of the apprenticeship, you can edit and resubmit it anytime. Find it here - <a href="#{edit_apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>Please let us know if you have any questions.</p>
        <p>Thanks,</p>
        <p>the GirlsGuild team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def self.complete_apprenticeship
    Apprenticeship.where('ends_at <= ?', Date.today).all.each do |app|
      app.signups.each {|a| a.complete}
      app.complete
    end
	end

	def already_applied?(user)
    self.signups.where(:user_id => user.id).any?
  end

  def get_signup(user)
  	if already_applied?(user)
  		return self.signups.where(user_id: user).first
  	else
  		return nil
  	end
  end

  def checkmarks
    checkmarks = {}
    checkmarks[:design] = self.group_valid?(:design)
    checkmarks[:private] = self.group_valid?(:private)
    checkmarks[:payment] = self.charge_id.present?
    self.errors.clear
    return checkmarks
  end

	state_machine :state, :initial => :started do
		event :complete do
      transition :all => :completed
    end
	end

  def countdown_message
    if self.started?
      return ''

    elsif self.pending?
      return "GirlsGuild is lookin it over."

    elsif self.accepted?
      if !self.confirmed_signups.empty?
        if self.datetime_tba
          return "#{self.confirmed_signups.count} of #{self.registration_max} Apprentices confirmed."
        elsif self.begins_at && Date.today < self.begins_at
          return "#{self.confirmed_signups.count} of #{self.registration_max} Apprentices confirmed.<br/><strong>#{(self.begins_at.mjd - Date.today.mjd)}</strong> days until it begins!".html_safe
        elsif self.ends_at && Date.today < self.ends_at
          return "#{self.ends_at - Date.today} more days of your Apprenticeship"
        else
          return ''
        end
      else
        return "Open for Applications"
      end
    elsif self.canceled?
    elsif self.filled?
        if self.datetime_tba
          return "Apprenticeship"
        elsif self.begins_at && Date.today < self.begins_at
          return "<strong>#{(self.begins_at.mjd - Date.today.mjd)}</strong> days until it begins!".html_safe
        elsif self.ends_at && Date.today < self.ends_at
          return "#{self.ends_at - Date.today} more days of your Apprenticeship"
        else
          return ''
        end
    elsif self.in_progress?
    elsif self.completed?
    end
    return ''
  end

end