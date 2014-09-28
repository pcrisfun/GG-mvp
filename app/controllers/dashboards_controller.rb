class DashboardsController < ApplicationController

  before_filter :authenticate_user!

  def display
    if current_user
      @events = current_user.events.sort_by { |e| e.created_at }.reverse!
      @signups = current_user.signups.sort_by { |s| s.created_at }.reverse!
      @preregs = current_user.preregs.sort_by { |p| p.created_at }.reverse!
    end
  end
  def admin
    if current_user
      @events = Event.all.sort_by { |e| e.created_at }.reverse!
      @signups = Signup.all.sort_by { |s| s.created_at }.reverse!
      @accepted_signups = AppSignup.where(state: 'accepted').sort_by { |e| e.created_at }.reverse!
    end
  end

  def avatar
    @user = User.find(current_user.id)
  end

  def update_avatar
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      redirect_to request.referrer, flash: { success: "Your avatar was successfully updated" }
    else
      redirect_to request.referrer, flash: { warning: "The following error(s) occurred: #{@user.errors.full_messages}"}
    end
  end

  def billing
    @user = User.find(current_user.id)
  end

  def update_billing
    @user = User.find(current_user.id)
    customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    logger.info "Retrieved Stripe customer"
    customer.card = stripe_card_token
    customer.description = "Updated card for #{@user.email}"

    if customer.save
      redirect_to request.referrer, flash: { success: "Your billing information was successfully updated" }
    else
      redirect_to request.referrer, flash: { warning: "The following error(s) occurred: #{@user.errors.full_messages}"}
    end
  end

end