class Interview < ActiveRecord::Base
  include Emailable
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor

  attr_accessible :app_signup, :interview_location, :interview_time, :user, :interview_message
  has_many :messages


  def app_signup
    Signup.find(app_signup_id)
  end

  def user
    app_signup.event.user
  end

  def deliver_interview_requested(opts={})
    app_signup.parent? ? deliver_interview_requested_parent(opts) : deliver_interview_requested_girl(opts)
  end

  def self.default_url_options
    ActionMailer::Base.default_url_options
  end

  def url_for_app_signup
    url_for(controller: 'app_signups', action: 'show', id: app_signup_id)
  end




  def deliver_interview_requested_maker(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "We've notified #{app_signup.user.first_name} that you'd like to meet up",
      :html_body => %(<h1>Thanks #{user.first_name},</h1>
        <p>We've notified #{app_signup.user.first_name} of your availability to meet up and asked her to choose 1 hour within these time-frame(s) that works for her.<br/>
        We'll let you know what she says.</p>
        <p>
          <b>Timeframe(s): </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>If something changes, you can reschedule any time by logging in and clicking <a href=#{url_for_app_signup}> reschedule</a>.</p>
        <p>Please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
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
        <p>#{user.first_name} would love to meet up to see if the apprenticeship is a good fit for <i>both</i> of you.</p>
        <p>
          <b>Timeframe(s): </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Please login to <a href=#{url_for_app_signup}>choose 1 hour within these timeframe(s) that will work for you</a>, or to reschedule for a different time.</p>
        <p>Please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
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
      :html_body => %(<h1>Howdy #{app_signup.user.first_name},</h1>
        <p>#{user.first_name} would love to meet up to see if the apprenticeship is a good fit for both her and #{app_signup.daughter_firstname}.</p>
        <p>
          <b>Timeframe: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Please login to <a href=#{url_for_app_signup}>choose 1 hour within these timeframe(s) that will work for you and #{app_signup.daughter_firstname}</a>, or to reschedule for a different time.</p>
        <p>Please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
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
      :html_body => %(<h1>Your meeting with #{user.first_name} is scheduled</h1>
        <p>Go ahead and add it to your calendar:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i><br/>
        </p>
        <p>Please log in if you need to <a href=#{url_for_app_signup}>reschedule</a> or <a href=#{url_for_app_signup}>send a message</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
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
      :html_body => %(<h1>Your meeting with #{user.first_name} is scheduled</h1>
        <p>Go ahead and add it to your calendar:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i><br/>
        </p>
        <p>Please log in if you need to <a href=#{url_for_app_signup}>reschedule</a> or <a href=#{url_for_app_signup}>send a message</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
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
      :html_body => %(<h1>Your meeting with #{app_signup.user.first_name} is scheduled</h1>
        <p>Go ahead and add it to your calendar:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i><br/>
        </p>
        <p>Please log in if you need to <a href=#{url_for_app_signup}>reschedule</a> or <a href=#{url_for_app_signup}>send a message</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end



  def deliver_interview_rescheduled(opts={})
    app_signup.parent? ? deliver_interview_rescheduled_parent(opts) : deliver_interview_rescheduled_girl(opts)
  end

  def deliver_interview_rescheduled_girl(opts={})
    Pony.mail({
      :to => "#{app_signup.user.name}<#{app_signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your interview with #{user.first_name} has changed!!",
      :html_body => %(<h1>Your meeting with #{user.first_name} has been rescheduled</h1>
        <p>Here are the new suggested time/locations:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i><br/>
        </p>
        <p>Go ahead and add it to your calendar - you're all set! <br/>
        If this doesn't work for you please login to <a href=#{url_for_app_signup}>reschedule for a different time</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_rescheduled_parent(opts={})
    Pony.mail({
      :to => "#{app_signup.user.name}<#{app_signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your interview with #{user.first_name} has changed!!",
      :html_body => %(<h1>Your meeting with #{user.first_name} has been rescheduled</h1>
        <p>Here are the new suggested time/locations:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i><br/>
        </p>
        <p>Go ahead and add it to your calendar - you're all set! <br/>
        If this doesn't work for you please login to <a href=#{url_for_app_signup}>reschedule for a different time</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_rescheduled_maker(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "Your interview with #{app_signup.user.first_name} has changed!!",
      :html_body => %(<h1>Your meeting with #{app_signup.user.first_name} has been rescheduled</h1>
        <p>Here are the new suggested time/locations:</p>
        <p>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i><br/>
        </p>
        <p>Go ahead and add it to your calendar - you're all set! <br/>
        If this doesn't work for you please login to <a href=#{url_for_app_signup}>reschedule for a different time</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end



  def deliver_interview_message(opts={})
    app_signup.parent? ? deliver_interview_message_parent(opts) : deliver_interview_message_girl(opts)
  end

  def deliver_interview_message_girl(opts={})
    Pony.mail({
      :to => "#{app_signup.user.name}<#{app_signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You have an interview message from #{user.first_name}!!",
      :html_body => %(<h1>You have an interview message from #{user.first_name}</h1>
        <p>
          <b>Message: </b> <i style="color: green;">#{interview_message}</i><br/>
          <br/>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Go ahead and add it to your calendar - you're all set! <br/>
        If this doesn't work for you please login to <a href=#{url_for_app_signup}>reschedule for a different time</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_message_parent(opts={})
    Pony.mail({
      :to => "#{app_signup.user.name}<#{app_signup.user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You have an interview message from #{user.first_name}!!",
      :html_body => %(<h1>You have an interview message from #{user.first_name}</h1>
        <p>
          <b>Message: </b> <i style="color: green;">#{interview_message}</i><br/>
          <br/>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Go ahead and add it to your calendar - you're all set! <br/>
        If this doesn't work for you please login to <a href=#{url_for_app_signup}>reschedule for a different time</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_interview_message_maker(opts={})
    Pony.mail({
      :to => "#{user.name}<#{user.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You have an interview message from #{app_signup.user.first_name}!!",
      :html_body => %(<h1>You have an interview message from #{app_signup.user.first_name}</h1>
        <p>
          <b>Message: </b> <i style="color: green;">#{interview_message}</i><br/>
          <br/>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Go ahead and add it to your calendar - you're all set! <br/>
        If this doesn't work for you please login to <a href=#{url_for_app_signup}>reschedule for a different time</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

  def deliver_new_message(message)
    sender = message.user
    if sender == user
      recipient = app_signup.user
    elsif sender == app_signup.user
      recipient = user
    end
    Pony.mail({
      :to => "#{recipient.name}<#{recipient.email}>",
      :from => "Diana & Cheyenne<hello@girlsguild.com>",
      :reply_to => "GirlsGuild<hello@girlsguild.com>",
      :subject => "You have an interview message from #{sender.first_name}!!",
      :html_body => %(<h1>You have an interview message from #{sender.first_name}</h1>
        <p>
          <b>Message: </b> <i style="color: green;">#{message.message_text}</i><br/>
          <br/>
          <b>Time: </b> <i>#{interview_time}</i><br/>
          <b>Location: </b> <i>#{interview_location}</i>
        </p>
        <p>Go ahead and add it to your calendar - you're all set! <br/>
        If this doesn't work for you please login to <a href=#{url_for_app_signup}>reschedule for a different time</a>.</p>
        <p>If you haven't already, please <a href="http://girlsguild.com/docs/interview_topics.pdf">print and bring this worksheet</a> of topics you should cover during the interview for communicating clear goals and expectations to see if it's a good fit for both of you.</p>
        <p>~<br/>Thanks,</br>The GirlsGuild Team</p>),
      :bcc => "hello@girlsguild.com",
    })
    return true
  end

end

