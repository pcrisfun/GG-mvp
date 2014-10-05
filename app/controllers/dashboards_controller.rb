class DashboardsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :current_admin, only: :admin

  def display
    if current_user
      @events = current_user.events.sort_by { |e| e.created_at }.reverse!
      @signups = current_user.signups.sort_by { |s| s.created_at }.reverse!
      @preregs = current_user.preregs.sort_by { |p| p.created_at }.reverse!
    end
  end

  def admin
    if current_user && current_user.admin?
      @pending_apprenticeships = Apprenticeship.where(state: "pending").sort_by { |e| e.created_at }.reverse!
      @posted_apprenticeships = Apprenticeship.where(state: "accepted").sort_by { |e| e.created_at }.reverse!
      @filled_apprenticeships = Apprenticeship.where(state: "filled").sort_by { |e| e.created_at }.reverse!
      @saved_apprenticeships = Apprenticeship.where(state: "started").sort_by { |e| e.created_at }.reverse!
      @canceled_apprenticeships = Apprenticeship.where(state: "canceled").sort_by { |e| e.created_at }.reverse!
      @completed_apprenticeships = Apprenticeship.where(state: "completed").sort_by { |e| e.created_at }.reverse!

      @pending_workshops = Workshop.where(state: "pending").sort_by { |e| e.created_at }.reverse!
      @posted_workshops = Workshop.where(state: "accepted").sort_by { |e| e.created_at }.reverse!
      @filled_workshops = Workshop.where(state: "filled").sort_by { |e| e.created_at }.reverse!
      @saved_workshops = Workshop.where(state: "started").sort_by { |e| e.created_at }.reverse!
      @canceled_workshops = Workshop.where(state: "canceled").sort_by { |e| e.created_at }.reverse!
      @completed_workshops = Workshop.where(state: "completed").sort_by { |e| e.created_at }.reverse!

      @signups = Signup.all.sort_by { |s| s.created_at }.reverse!
      @preregs = Prereg.all.sort_by { |p| p.created_at }.reverse!
      # @accepted_signups = AppSignup.where(state: 'accepted').sort_by { |e| e.created_at }.reverse!
    end
  end

  def metrics
    if current_user && current_user.admin?
      logger.info "Rendering metrics dashboard"
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
    customer.card = params[:stripe_card_token]
    customer.description = "Updated card for #{@user.email}"

    if customer.save
      logger.info "#{@user.first_name}'s Stripe customer info was updated"
      redirect_to request.referrer, flash: { success: "Your billing information was successfully updated" }
    else
      redirect_to request.referrer, flash: { warning: "The following error(s) occurred: #{@user.errors.full_messages}"}
    end
  end

end