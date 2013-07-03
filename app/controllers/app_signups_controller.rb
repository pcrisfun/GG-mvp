class AppSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
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
    @app_signup.user_id = current_user.id
  end

  def new_parent_app_signup
    @apprenticeship = Apprenticeship.find(params[:apprenticeship_id])
    @app_signup = AppSignup.new
    @app_signup.event_id = @apprenticeship.id
    @app_signup.user_id = current_user.id
    @app_signup.parent = true
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
          redirect_to apprenticeship_path(@app_signup.event), flash: { success: "Nice! Your application was saved." }
        else
          flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
          render 'new_parent_app_signup'
        end
      elsif @app_signup.group_valid?(:save) && @app_signup.save(:validate => false) && @app_signup.deliver_save
        redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Nice! Your application was saved." }
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        render 'new'
      end
    else
      if @app_signup.save && @app_signup.apply
        if @app_signup.parent?
          @app_signup.deliver_parent && @app_signup.deliver_maker_daughter
        else
          @app_signup.deliver && @app_signup.deliver_maker
        end
        redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}. We've sent an email to #{current_user.email} with the details." }
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        if @app_signup.parent?
          render 'new_parent_app_signup'
        else
          render 'new'
        end
      end
    end
  end

  def destroy
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    @app_signup.deliver_destroy && @app_signup.destroy
    redirect_to apprenticeships_path, :flash => { :success => "Application deleted." }
  end


  def update
    @app_signup.event_id = @apprenticeship.id
    @app_signup.user_id = current_user.id
    current_user.update_attributes(params[:user])

    if params[:save_button] == "Save for Later"
      if @app_signup.update_attributes(params[:app_signup])
        redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Nice! Your application was saved." }
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        if @app_signup.parent?
          render 'new_parent_app_signup'
        else
          render 'new'
        end
      end
    else
      if @app_signup.update_attributes(params[:app_signup])
        if @app_signup.apply
          @app_signup.deliver && @app_signup.deliver_maker
          redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}." }
        else
          flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
          if @app_signup.parent?
            render 'new_parent_app_signup'
          else
            render 'new'
          end
        end
      else
        flash.now[:warning] = "Oops! There was a problem saving your application. Please check all fields."
        if @app_signup.parent?
          render 'new_parent_app_signup'
        else
          render 'new'
        end
      end
    end
  end

  def show
  end

  def decline
    # !!!commented out by Scott because it doesn't seem to make sense here (and shouldn't really be in the update action either)
    # @app_signup.event_id = @apprenticeship.id
    # @app_signup.user_id = current_user.id
    # current_user.update_attributes(params[:user])
    @app_signup.decline && @app_signup.deliver_decline && @app_signup.deliver_decline_maker
    redirect_to apprenticeship_path(@app_signup.event), :flash => { :warning => "Apprenticeship declined. Thanks! We'll let her know you were honored that she wanted to work together but you found someone else." }
  end

  def accept
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    @app_signup.accept && @app_signup.deliver_accept && @app_signup.deliver_accept_maker
    redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Yahooo! You've accepted this apprentice. She'll have 2 weeks to confirm, and when she does we'll put you in touch!" }
  end

  def cancel
    @app_signup.cancel
    redirect_to apprenticeship_path(@app_signup.event), :flash => { :warning => "Drat! Your application has been canceled. Feel free to re-apply any time!"}
  end

  def confirm
    #add phone? current_user.update_attributes(params[:user])
    if params[:app_signup][:stripe_card_token].present?
      if @app_signup.update_attributes(params[:app_signup])
        if @app_signup.process_apprent_fee
          if @app_signup.confirm && @app_signup.deliver_confirm && @app_signup.deliver_confirm_maker
            redirect_to payment_confirmation_app_signup_path(@app_signup), flash: { success: "Awesome, you're confirmed to work with #{@apprenticeship.host_firstname}." } and return
          else
            flash[:warning] = "Oh snap, there was a problem saving your form. Please check all fields and try again."
            render 'show'
          end
        else
          flash[:warning] = "Hmm, we couldn't process payment. Please try again."
          render 'show'
        end
      else
        flash[:warning] = "Oh snap, there was a problem saving your form. Please check all fields and try again."
        render 'show'
      end
    elsif @app_signup.charge_id.present?
      if @app_signup.confirm && @app_signup.deliver_confirm && @app_signup.deliver_confirm_maker
        redirect_to payment_confirmation_app_signup_path(@app_signup), flash: { success: "Awesome, you're confirmed to work with #{@apprenticeship.host_firstname}." } and return
      else
        flash[:warning] = "Oh snap, there was a problem saving your form. Please check all fields and try again."
        render 'show'
      end
    else
      flash[:warning] = "Oh snap, there was a problem saving your form. Please check all fields and try again."
      render 'show'
    end
  end

  def payment_confirmation
  end

  def edit
  end

  def owner_user
    redirect_to apprenticeships_path unless current_user.admin? || current_user==@app_signup.user || current_user==@app_signup.event.user
  end
end