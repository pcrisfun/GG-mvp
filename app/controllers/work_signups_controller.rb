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

  def new_parent
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
      process_signup && @work_signup.signup
    else
      flash.now[:notify] = 'There was an error signing up.'
      if @work_signup.parent?
        render 'new_parent'
      else
        render 'new'
      end
    end
  end

  def destroy
    @work_signup = WorkSignup.find(params[:id]) if params[:id]
    if @work_signup.parent?
      @work_signup.deliver_destroy_parent && @work_signup.deliver_parent
    else
      @work_signup.deliver_destroy && @work_signup.deliver
    end
    @work_signup.destroy
    redirect_to workshops_path, :flash => { :success => "Workshop deleted." }
  end

  def update
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id
    current_user.update_attributes(params[:user])

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
    redirect_to workshops_path, :flash => { :warning => "Your workshop sign up has been canceled."}
  end

  private

  def process_signup
    begin
      @work_signup.process_signup!
      @charge = Stripe::Charge.retrieve(@work_signup.charge_id)
      if @work_signup.parent?
        @work_signup.deliver_parent(payment: @charge) && @work_signup.deliver_maker
      else
        @work_signup.deliver(payment: @charge) && @work_signup.deliver_maker
      end
      redirect_to workshops_path, :flash => { :success => "Awesome, you're all signed up to work with #{@workshop.host_firstname}." }
    rescue PaymentError
      flash.now[:warning] = 'There was an error processing your payment.'
      render 'new'
    rescue SignupError
      flash.now[:warning] = 'There was an error signing up for this workshop.'
      render 'new'
    end
  end

end
