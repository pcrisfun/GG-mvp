class Apprenticeship < Event

  has_many :users, :through => :signup
  has_many :users, :through => :prereg

  validation_group :design do
  # Title & Description
    validates_presence_of :topic
    validates_presence_of :host_firstname
    validates_presence_of :host_lastname
    validates_presence_of :kind
    validates_presence_of :description
  # Images
    validate :host_album_limit
  # Dates
    validates :begins_at, :date => {:after => Proc.new { Date.today }, :message => 'Oops! You need to plan your apprenticeship to start sometime after today. Please check the dates you set.'}, :if => :should_validate_begins_at?
    validates :ends_at, :date => {:after => :begins_at, :message => "Oops! Please check the dates you set. Your apprenticeship can't end before it begins!"}, :if => :tba_is_blank
  # Hours & Availability
    validates_presence_of :hours
    validates_numericality_of :hours, :greater_than => 0
    validates_presence_of :availability
  # Address & Neighborhood
    validates_presence_of :location_address, :location_city, :location_state
    validates_presence_of :location_nbrhood, :if => :residential
  # Age
    validates_presence_of :age_min
    validates_presence_of :age_max
    validates_numericality_of :age_min, :greater_than => 0
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set.", :if => :age_min_is_set
  # Registration
    validates_presence_of :registration_max
    validates_numericality_of :registration_max, :greater_than_or_equal_to => 1, :message => " The number of apprentices must be greater than 0.", :if => :reg_min_is_set
  # Skills & Tools
    validates_presence_of :skill_list, :tool_list
  end

  validation_group :private do
    validates_presence_of :permission, :message => "We need your permission to run a background check."
    validates_presence_of :legal_name, :message => "We'll need your legal full name in order to run a background check."
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

  validation_group :begins_at do
    validates :begins_at, :date => {:after => Proc.new { Date.today }, :message => 'Sorry! You need to plan your apprenticeship to start sometime after today. Please check the dates you set.'}, :if => :should_validate_begins_at?
  end

  validation_group :ends_at do
    validates :ends_at, :date => {:after => :begins_at, :message => "Oops! Please check the dates you set. Your apprenticeship can't end before it begins!"}, :if => :tba_is_blank
  end
  validation_group :hours do
    validates_numericality_of :hours, :greater_than => 0
  end
  validation_group :availability do
    validates_presence_of :availability
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
    validates_presence_of :age_min
    validates_numericality_of :age_min, :greater_than => 0
  end
  validation_group :age_max do
    validates_presence_of :age_max
    validates_numericality_of :age_max, :greater_than => :age_min, :message => " must be greater than the minimum age you set.", :if => :age_min_is_set
  end
  validation_group :registration_max do
    validates_presence_of :registration_max
    validates_numericality_of :registration_max, :greater_than_or_equal_to => 1, :message => " The number of apprentices must be greater than 0.", :if => :reg_min_is_set
  end
  validation_group :skill_list do
    validates_presence_of :skill_list
  end
  validation_group :tool_list do
    validates_presence_of :tool_list
  end

  include Emailable

  def deliver_save
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
       :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You started building an apprenticeship!",
      :html_body => %(<h1>Hooray #{user.first_name}!</h1>
        <p>We're thrilled you're building an apprenticeship! If you get stuck take a look at our <a href="#{faq_url}">FAQ</a>, or feel free to respond to this email with any questions you might have!</p>
        <p>You can <a href="#{edit_apprenticeship_url(self)}">edit your apprenticeship here</a> or monitor signups from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
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
        <p>We received your $30.00 listing fee, and your apprenticeship has been submitted and is pending while we take a look at it.</p>
        <p>You can review the submitted apprenticeship here - <a href="#{apprenticeship_url(self)}"> #{self.title}</a> or monitor signups from your <a href="#{dashboard_url}">Events Dashboard</a></p>
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
      :subject => "Your apprenticeship has been resubmitted! - #{topic} with #{user.name}",
      :html_body => %(<h1>Nice!</h1>
        <p>Your apprenticeship is currently pending while we take a look at your changes.</p>
        <p>You can review your resubmitted apprenticeship here - <a href="#{apprenticeship_url(self)}"> #{self.title}</a> or monitor signups from your <a href="#{dashboard_url}">Events Dashboard</a></p>
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
      :subject => "Your apprenticeship has been posted! - #{topic} with #{user.name}",
      :html_body => %(<h1>Congrats #{user.first_name}!</h1>
        <p>Your apprenticeship has been posted and is now live! Check it out - <a href="#{apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>Be sure to invite your friends and share it on your social networks!</p>
        <p>1. We'll forward you each application as soon as someone applies.
          <br/>2. You'll have two weeks to decide whether to accept or decline each apprentice.
          <br/>3. If you'd like to meet up first to determine whether you'll be a good fit, just let us know and we'd be happy to set up a meeting before you accept an apprentice!
          <br/>4. The post will be closed when you've accepted #{self.registration_max} apprentices. If you don't find a good fit you're not obligated to accept an apprentice.</p>
        <p>If by some bad luck you need to cancel your apprenticeship, you can do so from your <a href="#{dashboard_url}">Events Dashboard</a> - but we're crossing our fingers that won't happen!
          <br/>Let us know if you have any questions!</p>
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
      :subject => "Your apprenticeship has been canceled - #{topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>You've canceled your apprenticeship. We hope you'll consider offering it again sometime!</p>
        <p>You can edit the apprenticeship and resubmit it anytime. Find it here - <a href="#{edit_apprenticeship_url(self)}"> #{self.title}</a></p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_cancel_applicants
    Pony.mail({
      :to => "#{self.signup.user.name}<#{self.signup.user.email}>",
      :from => "Cheyenne & Diana<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Apprenticeship has been canceled - #{topic} with #{user.name}",
      :html_body => %(<h1>Bummer!</h1>
        <p>We're sorry to say that #{user.name} has had to cancel her apprenticeship. It may be rescheduled later, and if it is you'll be the first to know!</p>
        <p>In the meantime you can check out other upcoming apprenticehsips you might like here: <a href="#{url_for(apprenticeships)}"> #{apprenticeships_path}</a></p>
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
      :subject => "We couldn't post your apprenticeship - #{topic} with #{user.name}",
      :html_body => %(<h1>Sorry.</h1>
        <p>We can't post your apprenticeship because there was a problem with your submission:</p>
        <p><i>#{self.reject_reason}</i></p>
        <p>If the problem is with the formatting or content of the apprenticeship, you can edit and resubmit it anytime. Find it here - <a href="#{edit_apprenticeship_url(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
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
      :subject => "Your apprenticeship has been taken down - #{topic} with #{user.name}",
      :html_body => %(<h1>Sorry.</h1>
        <p>We've had to take down your apprenticeship because of an issue:</p>
        <p><i>#{self.revoke_reason}</i></p>
        <p>If the problem is with the formatting or content of the apprenticeship, you can edit and resubmit it anytime. Find it here - <a href="#{edit_apprenticeship_url(self)}"> #{self.title}</a> or from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>Please let us know if you have any questions.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def self.complete_apprenticeship
    Apprenticeship.where(:state => ["accepted", "filled"]).where('ends_at <= ?', Date.today-1.days).each do |app|
      #I don't know why app.complete doesn't work, but it doesn't and this does:
      app.state = "completed"
      app.save!(validate: false)
      app.signups.where(:state => "confirmed").each {|a| a.complete}
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

  # def application_confirmed?(user)
  #   if already_applied?(user) && self.signups.where(user_id: user).where(:state => ["confirmed", "completed"])
  #     return true
  #   end
  # end

  def checkmarks
    checkmarks = {}
    checkmarks[:design] = self.group_valid?(:design)
    checkmarks[:private] = self.group_valid?(:private)
    checkmarks[:payment] = self.charge_id.present?
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
      return "Your apprenticeship is saved"

    elsif self.pending?
      return "GirlsGuild is lookin it over"

    elsif self.accepted?
      if self.datetime_tba
        if self.submitted_preregs.empty?
          return "Open to Follow"
        else
          return "#{self.submitted_preregs.count} follower(s) for this event."
        end
      elsif !self.confirmed_signups.empty?
        if self.begins_at && Date.today < self.begins_at
          return "#{self.confirmed_signups.count} of #{self.registration_max} Apprentices confirmed.<br/><strong>#{(self.begins_at.mjd - Date.today.mjd)}</strong> days until it begins!".html_safe
        elsif self.ends_at && Date.today < self.ends_at
          return "#{self.ends_at.mjd - Date.today.mjd} more days of your Apprenticeship"
        else
          return ''
        end
      else
        return "#{self.confirmed_signups.count} of #{self.registration_max} participants confirmed. Open for Applications"
      end
    elsif self.canceled?
      return "You've canceled this apprenticeship"
    elsif self.filled?
        if self.datetime_tba
          return "Apprenticeship"
        elsif self.begins_at && Date.today < self.begins_at
          return "<strong>#{(self.begins_at.mjd - Date.today.mjd)}</strong> days until it begins!".html_safe
        elsif self.ends_at && Date.today < self.ends_at
          return "#{self.ends_at.mjd - Date.today.mjd} more days of your Apprenticeship"
        else
          return ''
        end
    elsif self.completed?
      return "Your apprenticeship is over :-)"
    end
    return ''
  end

end