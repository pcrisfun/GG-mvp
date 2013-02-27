class AppSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :owner_user, only: [:edit, :update]

  def new
  	@apprenticeship = Apprenticeship.find(params[:apprenticeship_id])
  	@app_signup = AppSignup.new
  end

  def create
	  @apprenticeship = Apprenticeship.find(params[:apprenticeship_id])

  	current_user.update_attributes(params[:user])

    @app_signup = AppSignup.new(params[:app_signup])
    @app_signup.event_id = @apprenticeship.id
    @app_signup.user_id = current_user.id

    if @app_signup.process_apprent_fee
      if @app_signup.save
        if @app_signup.submit && @app_signup.deliver
          redirect_to apprenticeships_path, :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}." }
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

  def owner_user
    redirect_to apprenticeships_path unless current_user.admin? || current_user==@app_signup.user
  end
end