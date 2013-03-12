class AppSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :load_app_signup
  before_filter :owner_user, only: [:edit, :update]

  def load_app_signup
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    @apprenticeship = @app_signup.event if @app_signup
  end

  def new
  	@apprenticeship = Apprenticeship.find(params[:apprenticeship_id])
  	@app_signup = AppSignup.new
  end

  def create
	  @apprenticeship = Apprenticeship.find(params[:apprenticeship_id])
    @app_signup = AppSignup.new(params[:app_signup])
    @app_signup.event_id = @apprenticeship.id
    @app_signup.user_id = current_user.id
    current_user.update_attributes(params[:user])

    if params[:save_button] == "Save for Later"
      #if @apprenticeship.group_valid?(:save) && @apprenticeship.save(:validate => false) && @apprenticeship.deliver_save
      if @app_signup.save && @app_signup.deliver_save
        redirect_to apprenticeships_path, :flash => { :success => "Nice! Your application was saved." }
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        render 'new'
      end
    else
      if @app_signup.save
        if @app_signup.apply && @app_signup.deliver
          redirect_to apprenticeships_path, :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}." }
        else
          flash.now[:warning] = "Welp, that submit didn't work."
          render 'new'
        end
      else
        flash.now[:warning] = "Glurphhh, that save didn't work."
        render 'new'
      end
    end
  end

  def update
    @app_signup.event_id = @apprenticeship.id
    @app_signup.user_id = current_user.id
    current_user.update_attributes(params[:user])

    if params[:save_button] == "Save for Later"
      if @app_signup.update_attributes(params[:app_signup])
        render 'show', :flash => { :success => "Nice! Your application was saved." }
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        render 'new'
      end

    elsif params[:reject_button]
      @app_signup.reject
      redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship rejected." }

    elsif params[:accept_button]
      @app_signup.accept
      redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship accepted." }

    else
      if @app_signup.update_attributes(params[:app_signup])
        if @app_signup.apply && @app_signup.deliver
          redirect_to apprenticeships_path, :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}." }
        else
          flash.now[:warning] = "Welp, that submit didn't work."
          render 'new'
        end
      else
        flash.now[:warning] = "Glurphhh, that save didn't work."
        render 'new'
      end
    end
  end

  def show
  end

  def edit
  end

  def owner_user
    redirect_to apprenticeships_path unless current_user.admin? || current_user==@app_signup.user
  end
end