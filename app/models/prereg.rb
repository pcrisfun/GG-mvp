class Prereg < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor
  include ApplicationHelper

  belongs_to :user
  belongs_to :event

  attr_accessible :event_id, :user_id


  def default_url_options
    if Rails.env.development?
      { :host => 'localhost:3000'}
    else
      { :host => 'girlsguild.com'}
    end
  end

  def deliver_prereg
    return false unless valid?
    Pony.mail({
                  :to => "#{event.user.name}<#{event.user.email}>",
                  :from => "Diana & Cheyenne<hello@girlsguild.com>",
                  :reply_to => "GirlsGuild<hello@girlsguild.com>",
                  :subject => "#{user.first_name} followed you on GirlsGuild!",
                  :html_body => %(<h1>Yay #{event.host_firstname}!</h1> <p>#{user.first_name} is a #{user.age}-year-old who wants to keep tabs on your future events! They were checking out your #{event.type}, <a href="#{url_for(controller: event.class.name.underscore.pluralize, action: 'show', id: event.id)}">#{event.topic}</a>, and signed up to follow you in case you decide to offer an apprenticeship or workshop again in the future. If you do, we'll give #{user.first_name} first dibs on signing up for it, before we announce it to the whole community.</p>
                      <p>That makes a total of #{event.preregs.count} follower(s) who are interested in your events.</p>
                      <p>You can see who else is following you by visiting your <a href="#{dashboard_url}">your dashboard</a>.</p>
                      <p>~<br/>xo,</br>The GirlsGuild Team</p>),
                  :bcc => "hello@girlsguild.com",
              })
    return true
  end

end