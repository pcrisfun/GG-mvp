class WorkSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def new
  	@workshop = Workshop.find(params[:workshop_id])
  	@work_signup = WorkSignup.new
  end

  def create
	@workshop = Workshop.find(params[:workshop_id])

  	current_user.update_attributes(params[:user])

    @work_signup = WorkSignup.new(params[:work_signup])
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id

    if @work_signup.process_workshop_fee
      if @work_signup.save
        if @work_signup.submit
          redirect_to workshops_path, :flash => { :success => "Awesome, you're all signed up to work with #{@workshop.host_firstname}." }
        else
          flash.now[:warning] = "Welp, that submit didn't work."
          render 'new'
        end
      else
        flash.now[:warning] = "Glurphhh, that save didn't work."
        render 'new'
      end
    else
      flash.now[:notify] = "You didn't think payment would just work, did you?"
      render 'new'
    end

  end

end
