class AppSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :load_app_signup
  before_filter :owner_user, only: [:edit, :update]

  def load_app_signup
    if params[:app_signup] && params[:app_signup][:id]
      @app_signup = AppSignup.find(params[:app_signup][:id])
    else
      @app_signup = AppSignup.find(params[:id]) if params[:id]
    end
    @apprenticeship = @app_signup.event if @app_signup
  end

  def new
    @apprenticeship = Apprenticeship.find(params[:apprenticeship_id])
    @app_signup = AppSignup.new
    @app_signup.event_id = @apprenticeship.id
    if params[:parent]
      @app_signup.parent = params[:parent]
    end
  end

  def create
    @apprenticeship = Apprenticeship.find(params[:apprenticeship_id])
    @app_signup = AppSignup.new(params[:app_signup])
    @app_signup.event_id = @apprenticeship.id
    @app_signup.user_id = current_user.id
    current_user.update_attributes(params[:user])

    if params[:save_button] == "Save for Later"
      if @app_signup.parent?
        if @app_signup.save(:validate => false) && @app_signup.deliver_save_parent
          redirect_to apprenticeships_path, flash: { success: "Nice! Your application was saved." }
        else
          flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
          render 'new'
        end
      elsif @app_signup.group_valid?(:save) && @app_signup.save(:validate => false) && @app_signup.deliver_save
        redirect_to apprenticeships_path, :flash => { :success => "Nice! Your application was saved." }
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        render 'new'
      end
    else
      if @app_signup.save && @app_signup.apply
        if @app_signup.parent?
          @app_signup.deliver_parent && @app_signup.deliver_maker
        else
          @app_signup.deliver && @app_signup.deliver_maker
        end
        redirect_to apprenticeships_path, :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}." }
      else
        flash.now[:warning] = "Glurphhh, that save didn't work."
        render 'new'
      end
    end
  end

  def destroy
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    if @app_signup.parent?
      @app_signup.deliver_destroy_parent
    else
      @app_signup.deliver_destroy
    end
    @app_signup.destroy
    redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship deleted." }
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
    else
      if @app_signup.update_attributes(params[:app_signup])
        if @app_signup.apply
          if @app_signup.parent?
            @app_signup.deliver_parent && @app_signup.deliver_maker
          else
            @app_signup.deliver && @app_signup.deliver_maker
          end
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

  def decline
    @app_signup.event_id = @apprenticeship.id
    @app_signup.user_id = current_user.id
    current_user.update_attributes(params[:user])
    @app_signup.decline && @app_signup.deliver_decline && @app_signup.deliver_decline_maker
    redirect_to apprenticeships_path, :flash => { :warning => "Application declined." }
  end

  def accept
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    @app_signup.accept && @app_signup.deliver_accept && @app_signup.deliver_accept_maker
    redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship accepted." }
  end

  def confirm
    #add phone? current_user.update_attributes(params[:user])
    if @app_signup.parent?
      if params[:app_signup][:stripe_card_token].present?
        if @app_signup.update_attributes(params[:app_signup])
          if @app_signup.process_apprent_fee
            if @app_signup.confirm && @app_signup.deliver_confirm && @app_signup.deliver_confirm_maker && @app_signup.deliver_confirm_parent
              redirect_to apprenticeships_path, :flash => { :success => "01 Rad! You're all confirmed to start your apprenticeship!"}
            else
              flash[:warning] = "02 Snap, there was a problem saving your form. Please check all fields and try again."
              render 'show'
            end
          else
            flash[:warning] = "03 Hmm, we couldn't process payment. Please try again."
            render 'show'
          end
        else
          flash[:warning] = "04 Snap, there was a problem saving your form. Please check all fields and try again."
          render 'show'
        end
      else
        flash[:warning] = "05 Snap, there was a problem saving your form. Please check all fields and try again."
        render 'show'
      end
    else
      if params[:app_signup][:stripe_card_token].present?
        if @app_signup.update_attributes(params[:app_signup])
          if @app_signup.process_apprent_fee
            if @app_signup.confirm && @app_signup.deliver_confirm && @app_signup.deliver_confirm_maker && @app_signup.deliver_confirm_parent
              redirect_to apprenticeships_path, :flash => { :success => "Rad! You're all confirmed to start your apprenticeship!"}
            else
              flash[:warning] = "07 Snap, there was a problem saving your form. Please check all fields and try again."
              render 'show'
            end
          else
            flash[:warning] = "08 Hmm, we couldn't process payment. Please try again."
            render 'show'
          end
        else
          flash[:warning] = "09 Snap, there was a problem saving your form. Please check all fields and try again."
          render 'show'
        end
      else
        flash[:warning] = "10 Whoops! Your form is missing some info. Please check all fields."
        render 'show'
      end
    end
  end

  def edit
  end

  def owner_user
    redirect_to apprenticeships_path unless current_user.admin? || current_user==@app_signup.user || current_user==@app_signup.event.user
  end
end