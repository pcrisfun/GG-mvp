class Prereg < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor

  belongs_to :user
  belongs_to :event

  attr_accessible :event_id, :user_id

  def default_url_options
    { :host => 'localhost:3000'}
  end

  def deliver_prereg
    return false unless valid?
    Pony.mail({
                  :to => "#{event.user.name}<#{event.user.email}>",
                  :from => "GirlsGuild<hello@girlsguild.com>",
                  :reply_to => "GirlsGuild<hello@girlsguild.com>",
                  :subject => "#{user.first_name} wants to work with you!",
                  :html_body => %(<h1>Yay #{event.user.first_name}!</h1> <p>She's a #{user.age}-year-old interested in learning <a href="#{url_for(self.event)}">#{event.topic}</a> with you. That makes #{event.preregs.count} girl(s) who are interested in working with you.</p>),
                  :bcc => "hello@girlsguild.com",
              })
    return true
  end

end