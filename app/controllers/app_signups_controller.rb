class AppSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_filter :load_app_signup
  before_filter :owner_user, only: [:edit, :update, :show]

  def load_app_signup
    if params[:app_signup] && params[:app_signup][:id]
      @app_signup = AppSignup.find(params[:app_signup][:id])
    else
      @app_signup = AppSignup.find(params[:id]) if params[:id]
    end
    @apprenticeship = @app_signup.event if @app_signup
    @interview = Interview.new
    # @interview.app_signup_id = @app_signup.id
    # @interview = Interview.new(add : @app_signup.id)
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
          redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Awesome, you've helped your daughter apply to work with #{@apprenticeship.host_firstname}. We've sent an email to #{current_user.email} with the details." }
        else
          @app_signup.deliver && @app_signup.deliver_maker
          redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Awesome, you've applied to work with #{@apprenticeship.host_firstname}. We've sent an email to #{current_user.email} with the details." }
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

  def destroy
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    @app_signup.deliver_destroy && @app_signup.destroy
    redirect_to apprenticeships_path, :flash => { :success => "Your application has been deleted. We hope you'll find another apprenticeship you're interested in!" }
  end


  def update
    #Commented out because they were commented out in work_signups update, because they might be shifting ownership of the signup
    #@app_signup.event_id = @apprenticeship.id
    #@app_signup.user_id = current_user.id

    current_user.update_attributes!(params[:user])

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
    elsif params[:decline_button]
      @app_signup.update_attributes(params[:app_signup])
      @app_signup.decline
      @app_signup.deliver_decline
      @app_signup.deliver_decline_maker
      redirect_to apprenticeship_path(@app_signup.event), :flash => { :warning => "Application declined. Thanks! We'll let her know you were honored that she wanted to work together but you found someone else." }
    elsif params[:accept_button]
      @app_signup.update_attributes(params[:app_signup])
      @app_signup.accept
      @app_signup.deliver_accept
      @app_signup.deliver_accept_maker
      redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Yahooo! You've accepted this apprentice. She'll have 2 weeks to confirm, and when she does we'll put you in touch!" }
    elsif params[:resubmit_button]
      @app_signup.update_attributes(params[:app_signup])
      if @app_signup.resubmit && @app_signup.deliver_resubmit && @app_signup.deliver_resubmit_maker
        redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Thanks! Your application was resubmitted. #{@apprenticeship.host_firstname} will review it, and we'll let you know her decision within two weeks."} and return
      else
        raise
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

  def cancel
    @app_signup = AppSignup.find(params[:id]) if params[:id]
    if @app_signup.confirmed? && @apprenticeship.filled?
      @apprenticeship.reopen
    end
    @app_signup.cancel && @app_signup.deliver_cancel && @app_signup.deliver_cancel_maker
    redirect_to apprenticeship_path(@app_signup.event), :flash => { :warning => "Drat! Your application has been canceled."}
  end

  # def resubmit
  #   if @app_signup.resubmit && @app_signup.deliver_resubmit && @app_signup.deliver_resubmit_maker
  #     redirect_to apprenticeship_path(@app_signup.event), :flash => { :success => "Thanks! Your application was resubmitted. #{@apprenticeship.host_firstname} will review it, and we'll let you know her decision within two weeks."} and return
  #   else
  #     raise
  #   end
  # rescue
  #   error_msg = " "
  #   @app_signup.errors.each do |field, msg|
  #     error_msg << "<br/>"
  #     error_msg << msg
  #   end
  #   redirect_to :back, :flash => { warning: "Oops. The following error(s) occured while attempting to resubmit your application: #{error_msg}".html_safe} and return
  # end

  def confirm
    current_user.update_attributes!(params[:user])

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
    else @app_signup.charge_id.present?
      if @app_signup.update_attributes(params[:app_signup])
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
  end

  def payment_confirmation
  end

  def edit
  end

  def owner_user
    redirect_to apprenticeships_path unless current_user.admin? || current_user==@app_signup.user || current_user==@app_signup.event.user
  end
end