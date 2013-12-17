class StripeController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def webhook
    data = JSON.parse request.body.read, :symbolize_names => true

    logger.debug("Received event with ID: #{data[:id]} Type: #{data[:type]}")

    # Retrieving the event from the Stripe API guarantees its authenticity
    event = Stripe::Event.retrieve(data[:id])

    if event.type == 'charge.succeeded'
      app_signup = AppSignup.find_by_charge_id(event.data.object.id)
      #app_signup.deliver_confirm(payment: event.data.object) if app_signup

      work_signup = WorkSignup.find_by_charge_id(event.data.object.id)
      #work_signup.deliver(payment: event.data.object) if work_signup

      app = Apprenticeship.find_by_charge_id(event.data.object.id)
     # app.deliver(payment: event.data.object) if app

      raise "Unable to find model for charge_id: #{event.data.object.id}" unless app_signup || work_signup || app
    end

    render :nothing => true
  end
end