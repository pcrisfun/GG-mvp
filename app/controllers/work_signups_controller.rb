class WorkSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]

  def new
  	@workshop = Workshop.find(params[:workshop_id])
  	@work_signup = WorkSignup.new
  end

  def create
	  @workshop = Workshop.find(params[:workshop_id])
    @work_signup = WorkSignup.new(params[:work_signup])
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id
  	current_user.update_attributes(params[:user])

    @workshop
    if @work_signup.save
      if @work_signup.process_workshop_fee
        if @work_signup.signup
          redirect_to workshops_path, :flash => { :success => "Awesome, you're all signed up to work with #{@workshop.host_firstname}." }
        else
          flash.now[:warning] = "Oops! There was a problem submitting your registration. Please check all fields."
          render 'new'
        end
      else
        flash.now[:warning] = "Oops! There was a problem submitting your registration. Please check all fields."
        render 'new'
      end
    else
      flash.now[:notify] = "Whoops! There was an error signing up."
      render 'new'
    end
  end

end
