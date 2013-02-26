class WorkSignup < Signup

#validates :parent, :presence => true
validates :waiver, :acceptance => true

  def is_parent
    :parent == true
  end

  def deliver
    return false unless valid?
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
          :from => "GirlsGuild<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You signed up for #{event.topic} with #{event.host_firstname} #{event.host_lastname}",
      :html_body => %(<h1>Thanks!</h1> <p>You're all signed up for '<a href="#{url_for(self.event)}">#{event.title}</a>. (Fill out this email with more info, etc)</p>,
      :bcc => "hello@girlsguild.com",
    })
    return true
  end
end