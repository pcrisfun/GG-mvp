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
                  :subject => "#{user.first_name} wants to work with you!",
                  :html_body => %(<h1>Yay #{event.host_firstname}!</h1> <p>#{user.first_name} is a #{user.age}-year-old interested in learning <a href="#{url_for(controller: event.class.name.underscore.pluralize, action: 'show', id: event.id)}">#{event.topic}</a> with you. That makes #{event.preregs.count} girl(s) who are interested in working with you.</p>
                      <p>You can keep tabs on who else is following you by visiting your <a href="#{dashboard_url}">your dashboard</a></p>),
                  :bcc => "hello@girlsguild.com",
              })
    return true
  end

end