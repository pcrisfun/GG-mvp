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
    validates_presence_of :legal_name, :message => "We'll need your full legal name in order to run a background check."
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

def should_validate_begins_at?
    :tba_is_blank && (self.started? || self.pending?)
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
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_duplicate
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
       :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You duplicated your previous apprenticeship",
      :html_body => %(<h1>Sweet #{user.first_name}!</h1>
        <p>We're happy you've duplicated your previous apprenticeship! You can still edit any details before submitting. If you get stuck take a look at our <a href="#{faq_url}">FAQ</a>, or feel free to respond to this email with any questions you might have!</p>
        <p>You can <a href="#{edit_apprenticeship_url(self)}">edit your apprenticeship here</a> or monitor signups from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
        <p>Your apprenticeship has been submitted and is pending while we take a look at it. We recieved your billing information, but we won't charge you the $30/per apprentice fee until your accepted apprentice(s) confirms.  You can update your <a href="#{update_billing_url}">Billing Info</a> at any time.</p>
        <p>You can review or edit the submitted apprenticeship here - <a href="#{apprenticeship_url(self)}"> #{self.title}</a> or monitor signups from your <a href="#{dashboard_url}">Events Dashboard</a></p>
        <p>If you havn't already, go ahead and fill out your profile in your <a href="#{edit_user_registration_url(user)}">Settings Dashboard</a> like your bio, and links to your website, twitter, and facebook - this will help us get the word out!</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
        <p>Be sure to invite your friends and share it on your social networks - and we'll do the same.</p>
        <p>1. We'll forward you each application as soon as someone applies.
          <br/>2. You'll have two weeks to decide whether to accept or decline each apprentice.
          <br/>3. You can schedule an interview before making the decision to accept or decline so that you can both determine whether it'll be a good fit!
          <br/>4. The post will be closed when you've accepted #{self.registration_max} apprentices. If you don't find a good fit you're not obligated to accept an apprentice.
          <br/>5. We'll only charge you the $30.00/apprentice fee after each apprentice you've chosen has confirmed the apprenticeship.</p>
        <p>If for some reason you need to cancel your apprenticeship, you can do so from your <a href="#{dashboard_url}">Events Dashboard.</a>
          <br/>Let us know if you have any questions!</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
        <p>You can duplicate your canceled apprenticeship and submit it again anytime. Find it in your <a href="#{dashboard_url}">Events Dashboard</a></a></p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_close
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
       :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship has been closed - #{topic} with #{user.name}",
      :html_body => %(<h1>Closed!</h1>
        <p>You've closed applications to your apprenticeship. This means that it will appear to be full and you won't receive anymore applications.</p>
        <p>You can keep track of your current applications from your <a href="#{dashboard_url}">Events Dashboard</a>.</p>
        <p>There are currently #{self.signups.where(:state => ['pending','interview_requested','interview_scheduled', 'accepted']).count} open applications:</p>
        <p>#{self.list_applications}</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_reopen
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
       :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your apprenticeship has been reopened - #{topic} with #{user.name}",
      :html_body => %(<h1>Reopened!</h1>
        <p>You've reopened your apprenticeship for applications. We'll keep you posted as new applications come in.</p>
        <p>You can keep track of your current applications from your <a href="#{dashboard_url}">Events Dashboard</a>.</p>
        <p>There are currently #{self.signups.where(:state => ['pending','interview_requested','interview_scheduled', 'accepted']).count} open applications:</p>
        <p>#{self.list_applications}</p>
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
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
        <p>~<br/>Thanks,<br/>Cheyenne & Diana<br/>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_help_posting
    Pony.mail({
        :to => "#{user.name}<#{user.email}>",
        :from => "Diana & Cheyenne<hello@girlsguild.com>",
        :reply_to => "GirlsGuild<hello@girlsguild.com>",
        :subject => "Any questions we can help with?",
        :html_body => %(<p>Hey #{user.first_name},</p>
          <p>We're glad you started an apprenticeship posting the other day. Do you have any questions about it?</p>
          <p>To find out what to expect from the process, take a look at our <a href="#{new_apprenticeship_url}">How it Works</a> page. For more details, check out the <a href="#{faq_url}">FAQ</a>. And if you have specific questions, just hit reply! We're happy to chat about it.</p>
          <p>To continue the posting and submit it, you can find it here - <a href="#{edit_apprenticeship_url(self)}"> #{self.title}</a>
          <p>~<br/>Thanks,<br/><br/>Cheyenne & Diana<br/>GirlsGuild Co-Founders</p>),
        :bcc => "hello@girlsguild.com",
    })
    self.update_column(:help_posting_sent, true)
    return true
  end

  def self.help_posting
    date_range = (Date.today-5.days)..(Date.today+1)
    Apprenticeship.where(state: "started", help_posting_sent: false, :created_at => date_range).each do |app|
      app.deliver_help_posting
    end
  end

  def list_applications
    "<ul>" + self.signups.where(:state => ['pending','interview_requested','interview_scheduled', 'accepted']).map do |a|
      "<li><a href=#{url_for(a)}> #{a.user.first_name}</a> (#{a.state})</li>"
    end.join + "</ul>"
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

  state_machine :state, :initial => :started do
    event :complete do
      transition :all => :completed
    end
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
      return "Your apprenticeship is complete"
    end
    return ''
  end

end