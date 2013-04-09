class AppSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :load_app_signup
  before_filter :owner_user, only: [:edit, :update]

  def load_app_signup
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    @apprenticeship = @app_signup.event if @app_signup
  end

  def index
    unless current_user.blank?
      @mysaved_app_signups = current_user.app_signups.find_all_by_state('started')
      @mypending_app_signups = current_user.app_signups.find_all_by_state('pending')
      @myactive_app_signups = current_user.app_signups.find_all_by_state('accepted')
      @mycanceled_app_signups = current_user.app_signups.find_all_by_state('canceled')
      @myfilled_app_signups = current_user.app_signups.find_all_by_state('filled')
      @mycompleted_app_signups = current_user.app_signups.find_all_by_state('completed')
    end
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
      if @app_signup.save(:validate => false) && @app_signup.deliver_save
      #if @app_signup.save && @app_signup.deliver_save
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
          flash.now[:warning] = "Welp, that submit didn't work in create."
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
      if @app_signup.update_attributes(params[:app_signup],:validate => false)
      #if @app_signup.update_attributes(params[:app_signup])
        render 'show', :flash => { :success => "Nice! Your application was saved." }
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        render 'new'
      end

    elsif params[:decline_button]
      @app_signup.decline && @app_signup.deliver_decline
      redirect_to apprenticeships_path, :flash => { :warning => "Application declined." }

    elsif params[:accept_button]
      @app_signup.accept && @app_signup.deliver_accept
      redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship accepted." }

    elsif params[:app_signup][:stripe_card_token].present?
      if @app_signup.update_attributes(params[:app_signup])
        if @app_signup.process_apprent_fee
          if @app_signup.confirm && @app_signup.deliver_confirm
            redirect_to apprenticeships_path, :flash => { :success => "Rad! You're all confirmed to start your apprenticeship!"}
          else
            flash[:warning] = "Whoops! Your form is missing some info. Please check all fields."
            render 'show'
          end
        else
          flash[:warning] = "Hmm, we couldn't process payment. Please try again."
          render 'show'
        end
      else
        flash[:warning] = "Snap, there was a problem saving your form. Please check all fields and try again."
        render 'show'
      end

    else
      if @app_signup.group_valid?(:submit) && @app_signup.update_attributes(params[:app_signup])
      #if @app_signup.update_attributes(params[:app_signup])
        if @app_signup.apply && @app_signup.deliver
          redirect_to apprenticeships_path, :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}." }
        else
          flash.now[:warning] = "Welp, that submit didn't work (app_signups controller > update)."
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