class Workshop < Event
include EventHelper

	has_many :users, :through => :signup
	has_many :users, :through => :prereg


  validation_group :design do
  # Title & Description
    validates_presence_of :topic
    validates_presence_of :description
  # Images
    validate :host_album_limit
  # Date & Time
    validates :begins_at, :date => {:after => Proc.new { Date.today }, :message => 'Sorry! You need to plan your workshop for a date after today. Please check the date you set.'}, :if => :should_validate_begins_at?
    validates_presence_of :begins_at_time, :ends_at_time, :if => :tba_is_blank
    validate :ends_after_start_time
    validate :close_signups
  # Address & Neighborhood
    validates_presence_of :location_address, :location_city, :location_state
    validates_presence_of :location_nbrhood, :if => :residential
  # Age
    validates_numericality_of :age_min, :greater_than => 0
    validates_numericality_of :age_max, :greater_than => :age_min, :message => "- Whoops, the maximum age must be greater than the minimum age you set.", :if => :age_min_is_set
  # Signups
    validates_presence_of :registration_min, :registration_max
    validates_numericality_of :registration_max, :greater_than_or_equal_to => :registration_min, :message => "- Whoops, the maximum number of participants must be the same or greater than the minimum you set.", :if => :reg_min_is_set
  # Price
    validates_presence_of :price
    validates_numericality_of :price, :greater_than_or_equal_to => 0
  # Skills & Tools
    validates_presence_of :skill_list, :tool_list
  end

  validation_group :private do
    validates_presence_of :permission, :message => "We need your permission to run a background check."
    validates_presence_of :legal_name, :message => "We'll need your legal full name in order to run a background check."
    validates_presence_of :payment_options
    validate :send_payment_to
  end

  validation_group :topic do
    validates_presence_of :topic
  end

  validation_group :description do
    validates_presence_of :description
  end

  validation_group :begins_at do
    validates :begins_at, :date => {:after => Proc.new { Date.today }, :message => 'Sorry! You need to plan your workshop for a date after today. Please check the date you set.'}, :if => :should_validate_begins_at?
  end

  validation_group :begins_at_time do
    validates_presence_of :begins_at_time, :if => :tba_is_blank
  end

  validation_group :ends_at_time do
    validates_presence_of :ends_at_time, :if => :tba_is_blank
    validate :ends_after_start_time
  end

  validation_group :ends_at do
    validates :ends_at, :date => {:before_or_equal_to => :begins_at, :message => 'Sorry! You need to close registrations on or before the date of the workshop.' }, :if => :tba_is_blank
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

  validation_group :location_nbrhood do
    validates_presence_of :location_nbrhood, :if => :residential
  end

  validation_group :age_min do
    validates_numericality_of :age_min, :greater_than => 0
  end

  validation_group :age_max do
    validates_numericality_of :age_max, :greater_than => :age_min, :message => "- Whoops, the maximum age must be greater than the minimum age you set.", :if => :age_min_is_set
  end

  validation_group :registration_min do
    validates_presence_of :registration_min
  end

  validation_group :registration_max do
    validates_presence_of :registration_max
    validates_numericality_of :registration_max, :greater_than_or_equal_to => :registration_min, :message => "- Whoops, the maximum number of participants must be the same or greater than the minimum you set.", :if => :reg_min_is_set
  end

  validation_group :price do
    validates_presence_of :price
    validates_numericality_of :price, :greater_than_or_equal_to => 0
  end

  validation_group :skill_list do
    validates_presence_of :skill_list
  end

  validation_group :tool_list do
    validates_presence_of :tool_list
  end

  def ends_after_start_time
    if !datetime_tba && ends_at_time && begins_at_time
      if ends_at_time <= begins_at_time
        errors.add(:ends_at_time, "Whoops, your workshop can't end before it starts! Please check the time you set.")
      end
    end
  end

  def close_signups
    if !datetime_tba && begins_at && ends_at
      if ends_at > begins_at
        errors.add(:ends_at, "Whoops, registrations need to close on or before the workshop date.")
      end
    end
  end

  def send_payment_to
    if payment_options == "Paypal"
      validates_presence_of :paypal_email
    elsif payment_options == "Check"
      validates_presence_of :sendcheck_address, :message => "- Please fill in the address where you'd like us to send your check."
    end
  end

 include Emailable

	def deliver_save
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been saved - #{topic} with #{user.name}",
			:html_body => %(<h1>Hooray #{user.first_name}!</h1>
        <p>We're thrilled you're building a workshop! If you get stuck take a look at our <a href="#{faq_url}">FAQ</a>, or feel free to respond to this email with any questions you might have!</p>
        <p>You can edit your workshop here - <a href="#{url_for(self)}"> #{self.title}</a> or monitor it from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver
		return false unless valid?
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been submitted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Thanks #{user.first_name}!</h1>
        <p>Your workshop has been submitted and is pending while we take a look at it.</p>
        <p>You can review the submitted workshop here - <a href="#{url_for(self)}"> #{self.title}</a> or monitor it from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>While you wait, go ahead and fill out your profile in your <a href="#{edit_user_registration_url(user)}">Settings Dashboard</a> like your bio, and links to your website, twitter, and facebook if you're into the social thing.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
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
			:subject => "Your workshop has been resubmitted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Nice!</h1>
        <p>Your workshop is currently pending while we take a look at your changes.</p>
        <p>You can review the updated workshop here - <a href="#{url_for(self)}"> #{self.title}</a> or monitor it from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_accept
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been posted! - #{topic} with #{user.name}",
			:html_body => %(<h1>Congrats #{user.first_name}!</h1>
        <p>Your workshop has been posted and is now live! Check it out - <a href="#{url_for(self)}"> #{self.title}</a></p>
        <p>Be sure to invite your friends and share it on your social networks!</p>
        <p>We'll let you know whenever someone signs up. Registrations will be closed when #{self.registration_max} people have signed up or on the date you set. </p>
        <p>If by some bad luck you need to cancel your workshop, you can do so from your <a href="#{dashboard_url}">Events Dashboard</a>. Likewise, if it turns out fewer than your minimum #{self.registration_min} participants sign up, the workshop will automatically be canceled on #{get_formated_date(self.ends_at, format: "%b %e, %Y")}. We think it's going to rock, though!</p>
        <p>Let us know if you have any questions!</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_cancel
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been canceled - #{topic} with #{user.name}",
			:html_body => %(<h1>Bummer!</h1>
        <p>You've canceled your workshop. We hope you'll consider offering it again sometime!</p>
        <p>You can edit the workshop and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

  def deliver_cancel_lowsignups
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop has been canceled - #{topic} with #{user.name}",
      :html_body => %(<h1>Rats!</h1>
        <p>Your workshop has been canceled because there were less than #{registration_min} signups. We hope you'll consider offering another workshop or apprenticeship sometime!</p>
        <p>You can always edit the workshop and resubmit it anytime. Find it here - <a href="#{url_for(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

	def deliver_reject
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "We couldn't post your workshop - #{topic} with #{user.name}",
			:html_body => %(<h1>Sorry.</h1>
        <p>We can't post your workshop because there was a problem with your submission:</p>
        <p><i>#{self.reject_reason}</i></p>
        <p>If the problem is with the formatting or content of the workshop, you can edit and resubmit it anytime. Find it here - <a href="#{edit_workshop_url(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Please let us know if you have any questions.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
	end

	def deliver_revoke
		Pony.mail({
			:to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
			:reply_to => "GirlsGuild<hello@girlsguild.com>",
			:subject => "Your workshop has been revoked - #{topic} with #{user.name}",
			:html_body => %(<h1>Sorry.</h1>
        <p>We've had to take down your workshop because of an issue:</p>
        <p><i>#{self.revoke_reason}</i></p>
        <p>If the problem is with the formatting or content of the workshop, you can edit and resubmit it anytime. Find it here - <a href="#{edit_workshop_url(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Please let us know if you have any questions.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
			:bcc => "hello@girlsguild.com",
		})
		return true
  end

  def deliver_maker_reminder
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your workshop is coming up! - #{self.title}",
      :html_body => %(<h1>3, 2, 1... it's almost time!</h1>
        <p>Just a reminder that your workshop is happening on #{self.begins_at}.</p>
        <p>So far, #{self.signups.where(:state => 'confirmed').count} people have signed up, and registration closes on #{get_formated_date(self.ends_at, format: "%b %e, %Y")}. We'll let you know if anyone new signs up before then!</p>
        <p>We've sent them a reminder too, but in case you want to send the participants directions to the location or instructions to prepare for the workshop, here are their email addresses: #{self.get_signup_emails}</p>
        <p>You can also view who has signed up from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:reminder_sent, true)
    return true
  end

  def deliver_maker_followup
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "How was your workshop? - #{self.title}",
      :html_body => %(<h1>Hey #{user.first_name}!</h1>
        <p>How did your workshop go? We'd love to hear about it.</p>
        <p>In case you want to follow up with the participants, here are their email addresses: #{self.get_signup_emails}</p>
        <p>Do you have any feedback, good or bad, on the process of posting and leading your workshop, or suggestions on what we can do to make it easier? We want to know what you think.</p>
        <p>We hope it was a great experience, and want to make it even better next time.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    self.update_column(:follow_up_sent, true)
    return true
  end

  def get_signup_emails
    "<ul>" + self.signups.where(:state => ["confirmed", "completed"]).map do |a|
      "<li>#{a.user.name}: #{a.user.email}</li>"
    end.join + "</ul>"
  end

	def self.complete_workshop
    Workshop.where(:state => ["accepted", "filled"]).where('begins_at <= ?', Date.today-1.days).each do |workshop|
      #I don't know why workshop.complete doesn't work, but it doesn't and this does:
      workshop.state = "completed"
      workshop.save!(validate: false)
      workshop.signups.where(:state => "confirmed").each {|w| w.complete}
    end
	end

  def self.cancel_workshop
    #Note: ends_at is the registration close date on workshops
    Workshop.where(state: "accepted").where('ends_at <= ?', Date.today).each do |w|
      unless w.min_capacity_met?
        w.cancel(validate: false) && w.deliver_cancel_lowsignups
        w.signups.where(state: "confirmed").each do |s|
          s.cancel && s.deliver_cancel

          Prereg.find_or_create_by_user_id_and_event_id!(
          :user_id => s.user_id,
          :event_id => w.id)
        end
      end
    end
  end

  def self.maker_reminder
    date_range = Date.today..(Date.today+3.days)
    Workshop.where(begins_at: date_range, :state => ["accepted", "filled"], reminder_sent: false).each do |work|
      work.deliver_maker_reminder
    end
  end

  def self.maker_followup
    date_range = (Date.today-3.days)..Date.today
    Workshop.where(begins_at: date_range, state: "completed", follow_up_sent: false).each do |work|
      work.deliver_maker_followup
    end
  end

  def total_price
    unless self.price
      return '___'
    end
    return (self.price/1.25).round.to_s
  end

  def checkmarks
    checkmarks = {}
    checkmarks[:design] = self.group_valid?(:design)
    checkmarks[:private] = self.group_valid?(:private)
    self.errors.clear
    return checkmarks
  end

  def state_label
    if self.started?
      return "saved"
    elsif self.accepted?
      return "posted"
    else
      return self.state
    end
  end

  def countdown_message
    if self.started?
      return "Your workshop is saved"

    elsif self.pending?
      return "GirlsGuild is lookin it over"

    elsif self.accepted?
      if !self.confirmed_signups.empty?
        if self.datetime_tba
          return "Posted as TBA, set a date when you're ready"
        elsif self.begins_at && Date.today < self.begins_at
          return "#{self.confirmed_signups.count} of #{self.registration_max} participants confirmed.<br/><strong>#{(self.ends_at.mjd - Date.today.mjd)}</strong> days for people to sign up.".html_safe
        else
          return "Passed"
        end
      else
        return "Open to Follow"
      end
    elsif self.canceled?
      return "You've canceled this workshop"
    elsif self.filled?
      if self.datetime_tba
        return "Workshop"
      elsif self.begins_at && Date.today < self.begins_at
        return "<strong>#{(self.begins_at.mjd - Date.today.mjd)}</strong> days until the Workshop!".html_safe
      else
        return ''
      end
    elsif self.completed?
      return "Your workshop is over :-)"
    end
    return ''
  end


end