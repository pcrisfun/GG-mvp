class WorkSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_filter :fetch_workshop

  def new
  	@work_signup = WorkSignup.new
  end

  def create
    @work_signup = WorkSignup.new(params[:work_signup])
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id
  	current_user.update_attributes(params[:user])

    if @work_signup.save
      process_signup
    else
      flash.now[:notify] = 'There was an error signing up.'
      render 'new'
    end
  end

  def update
    @work_signup = WorkSignup.find(params[:id])
    current_user.update_attributes(params[:user])

    if @work_signup.update_attributes(params[:work_signup])
      process_signup
    else
      flash.now[:notify] = 'There was an error signing up.'
      render 'new'
    end
  end

  private

  def process_signup
    begin
      @work_signup.process_signup!

      redirect_to workshops_path, :flash => { :success => "Awesome, you're all signed up to work with #{@workshop.host_firstname}." }
    rescue PaymentError
      flash.now[:warning] = 'There was an error processing your payment.'
      render 'new'
    rescue SignupError
      flash.now[:warning] = 'There was an error signing up for this workshop.'
      render 'new'
    end
  end

  def fetch_workshop
    @workshop = Workshop.find(params[:workshop_id])
  end
end
