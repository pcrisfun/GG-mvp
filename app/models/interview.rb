class Interview < ActiveRecord::Base
  include Emailable
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor

  attr_accessible :app_signup, :interview_location, :interview_time, :user



  def app_signup
    Signup.find(app_signup_id)
  end

  def user
    app_signup.event.user
  end

  def deliver_interview_requested(opts={})
    app_signup.parent? ? deliver_interview_requested_parent(opts) : deliver_interview_requested_girl(opts)
  end

  def deliver_interview_requested_maker(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "We've notified #{app_signup.user.first_name} that you'd like to meet up",
      :html_body => %(Thanks #{user.name},
        <p>We've notified #{app_signup.user.first_name} of your availability to meet up and asked her to choose 1 hour within these time-frame(s) that works for her.</p>
        <p>
          <b>Timeframe: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>You can reschedule any time by logging in and clicking <a href=#{url_for(controller: 'app_signups', action: 'show', id: app_signup_id, :host=>'localhost:3000')}>reschedule</a>.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_requested_girl(opts={})
    Pony.mail({
      :to => "#{app_signup.user.name}<#{app_signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.first_name} would like to meet up",
      :html_body => %(<h1>Howdy #{app_signup.user.first_name},</h1>
        <p>#{user.first_name} would love to meet up to see if the apprenticeship is a good fit for both of you.</p>
        <p>
          <b>Timeframe: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Please log in to <a href=#{url_for(controller: 'app_signups', action: 'show', id: app_signup_id, :host=>'localhost:3000')}>choose 1 hour within this timeframe(s) that will work for you</a>, or suggest a different time.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_requested_parent(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "#{user.first_name} would like to meet up",
      :html_body => %(<h1>Howdy #{app_signup.first_name},</h1>
        <p>#{user.first_name} would love to meet up to see if the apprenticeship is a good fit for both her and #{app_signup.daughter_firstname}.</p>
        <p>
          <b>Timeframe: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Please log in to <a href=#{url_for(controller: 'app_signups', action: 'show', id: app_signup_id, :host=>'localhost:3000')}>choose 1 hour within this timeframe(s) that will work for you and #{app_signup.daughter_firstname}</a>, or suggest a different time.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end




  def deliver_interview_scheduled(opts={})
    app_signup.parent? ? deliver_interview_scheduled_parent(opts) : deliver_interview_scheduled_girl(opts)
  end

  def deliver_interview_scheduled_girl(opts={})
    Pony.mail({
      :to => "#{app_signup.user.name}<#{app_signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You're all set to meet up with #{user.first_name}",
      :html_body => %(<h1>Hi #{app_signup.user.first_name},</h1>
        <p>at this time:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Please log in to if you need to <a href=#{url_for(controller: 'app_signups', action: 'show', id: app_signup_id, :host=>'localhost:3000')}>reschedule or send a message</a>.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_scheduled_parent(opts={})
    Pony.mail({
      :to => "#{app_signup.user.name}<#{app_signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You're all set to meet up with #{user.first_name}",
      :html_body => %(<h1>Hi #{app_signup.user.first_name},</h1>
        <p>at this time:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Please log in to if you need to <a href=#{url_for(controller: 'app_signups', action: 'show', id: app_signup_id, :host=>'localhost:3000')}>reschedule or send a message</a>.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_scheduled_maker(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You're all set to meet up with #{app_signup.user.first_name}",
      :html_body => %(<h1>Hi #{user.first_name},</h1>
        <p>at this time:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Please log in to if you need to <a href=#{url_for(controller: 'app_signups', action: 'show', id: app_signup_id, :host=>'localhost:3000')}>reschedule or send a message</a>.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end



end

