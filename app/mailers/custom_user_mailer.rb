# Custom mailer to overwrite headers in Devise emails (so we can bcc ourselves)
class CustomUserMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  def confirmation_instructions(record, opts={})
  	headers["bcc"] = "hello@girlsguild.com"
    super
  end
end