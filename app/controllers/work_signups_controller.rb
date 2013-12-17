class WorkSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_filter :load_work_signup


  def load_work_signup
    if params[:work_signup] && params[:work_signup][:id]
      @work_signup = WorkSignup.find(params[:work_signup][:id])
    else
      @work_signup = WorkSignup.find(params[:id]) if params[:id]
    end
    @workshop = @work_signup.event if @work_signup
  end

  def new
  	@workshop = Workshop.find(params[:workshop_id])
    @work_signup = WorkSignup.new
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id
  end

  def new_parent_work_signup
    @workshop = Workshop.find(params[:workshop_id])
    @work_signup = WorkSignup.new
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id
    @work_signup.parent = true
  end

  def create
    @workshop = Workshop.find(params[:workshop_id])
    @work_signup = WorkSignup.new(params[:work_signup])
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id
  	current_user.update_attributes(params[:user])

    if @work_signup.save
      process_signup
    else
      flash.now[:notify] = 'There was an error signing up.'
      if @work_signup.parent?
        render 'new_parent_work_signup'
      else
        render 'new'
      end
    end
  end

  def destroy
    @work_signup = WorkSignup.find(params[:id]) if params[:id]
    if @work_signup.parent?
      @work_signup.deliver_destroy_parent
    else
      @work_signup.deliver_destroy
    end
    @work_signup.destroy
    redirect_to workshops_path, :flash => { :success => "Workshop deleted." }
  end

  def update
    if @work_signup.update_attributes(params[:work_signup])
      process_signup
    else
      flash.now[:notify] = 'There was an error signing up.'
      render 'new'
    end
  end

  def show
  end

  def cancel
    @work_signup.cancel
    @work_signup.deliver_cancel_self
    if @workshop.filled?
      @workshop.reopen
    end
    redirect_to dashboard_path, :flash => { :warning => "Your workshop registration has been canceled."}
  end

  def payment_confirmation

  end

  private

  def process_signup
    begin
      @work_signup.process_signup!
      @charge = Stripe::Charge.retrieve(@work_signup.charge_id)
      @work_signup.signup
      if @work_signup.parent?
        @work_signup.deliver_parent(payment: @charge)
        @work_signup.deliver_maker_daughter
      elsif @work_signup.minor?
        @work_signup.deliver_minor(payment: @charge)
        @work_signup.deliver_maker
      else
        @work_signup.deliver_self(payment: @charge)
        @work_signup.deliver_maker
      end
      # redirect_to workshops_path, :flash => { :success => "Awesome, you're all signed up to work with #{@workshop.host_firstname}." }
      redirect_to payment_confirmation_work_signup_path(@work_signup), flash: { success: "Awesome, you're all signed up to work with #{@workshop.host_firstname}." } and return
    rescue PaymentError
      flash.now[:warning] = 'There was an error processing your payment.'
      render 'new'
    rescue SignupError
      flash.now[:warning] = 'There was an error signing up for this workshop.'
      render 'new'
    end
  end

end
