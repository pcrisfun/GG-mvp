class ApprenticeshipsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :current_apprenticeship, except: [:index, :info, :create, :save]
  before_filter :owner_user, only: [:edit, :private, :payment, :payment_confirmation, :update]
  before_filter :current_admin, only: :destroy
  before_filter :load_user_gallery

  def index
    unless current_user.blank?
  	  @mysaved_apprenticeships = current_user.apprenticeships.find_all_by_state('started', 'private', 'payment')
  	  @mypending_apprenticeships = current_user.apprenticeships.find_all_by_state('pending')
  	  @myactive_apprenticeships = current_user.apprenticeships.find_all_by_state('accepted')
      @mycanceled_apprenticeships = current_user.apprenticeships.find_all_by_state('canceled')
      @myfilled_apprenticeships = current_user.apprenticeships.find_all_by_state('filled')
      @mycompleted_apprenticeships = current_user.apprenticeships.find_all_by_state('completed')

      @allpending_apprenticeships = Apprenticeship.find_all_by_state('pending')
      @allsaved_apprenticeships = Apprenticeship.find_all_by_state('started')
      @allcanceled_apprenticeships = Apprenticeship.find_all_by_state('canceled')
      @allfilled_apprenticeships = Apprenticeship.find_all_by_state('filled')
      @allcompleted_apprenticeships = Apprenticeship.find_all_by_state('completed')

      @mysaved_app_signups = current_user.app_signups.find_all_by_state('started')
      @mypending_app_signups = current_user.app_signups.find_all_by_state('pending')
      @myaccepted_app_signups = current_user.app_signups.find_all_by_state('accepted')
      @mycanceled_app_signups = current_user.app_signups.find_all_by_state('canceled')
      @mycompleted_app_signups = current_user.app_signups.find_all_by_state('completed')
      @myconfirmed_app_signups = current_user.app_signups.find_all_by_state('confirmed')
    end
  	@apprenticeships = Apprenticeship.find_all_by_state(['accepted','filled','completed'])
  end

  def create
    if params[:apprenticeship]
      @apprenticeship = current_user.apprenticeships.new(params[:apprenticeship])
    else
      @apprenticeship = current_user.apprenticeships.new(topic: 'A New Apprenticeship', host_firstname: current_user.first_name, host_lastname: current_user.last_name, datetime_tba: true)
    end
    @apprenticeship.begins_at ||= Date.today
    @apprenticeship.ends_at ||= Date.tomorrow

    if @apprenticeship.group_valid?(:save) && @apprenticeship.save #&& @apprenticeship.deliver_save
      redirect_to edit_apprenticeship_path(@apprenticeship), :flash => { :success => "Nice! Let's Start by designing your apprenticeship." }
    else
      flash.now[:warning] = "Whoops! There was a problem starting your apprenticeship: #{@apprenticeship.errors.full_messages}"
      flash.now[:error] = @apprenticeship.errors.full_messages
      render 'info'
    end
  end

  def update
    if params[:name] && params[:value]
      if @apprenticeship.respond_to?(params[:name])
        if params[:value] == ""
          params[:value] = nil
        end
        @apprenticeship.update_attribute(params[:name], params[:value])
        @apprenticeship.state = 'started'
        @apprenticeship.save
        if ['topic', 'host_firstname', 'host_lastname'].include? params[:name]
          @apprenticeship.generate_title
        end
        respond_to do |format|
          format.json { render json: @apprenticeship }
        end
      end
    else
      if params[:apprenticeship]
        if @apprenticeship.update_attributes(params[:apprenticeship])
          if params[:apprenticeship][:stripe_card_token] && ( params[:apprenticeship][:stripe_card_token] != "" )
            if @apprenticeship.process_payment
              @apprenticeship.paid
              redirect_to payment_confirmation_apprenticeship_path(@apprenticeship)
            else
              redirect_to payment_apprenticeship_path(@apprenticeship), :flash => { warning: "There was a problem processing your payment: #{@apprenticeship.errors.full_messages}" }
            end
          else
            redirect_to payment_apprenticeship_path(@apprenticeship)
          end
        else
          redirect_to private_apprenticeship_path(@apprenticeship), :flash => { warning: "Please check all fields. You cannot pay until the following have been corrected: #{@apprenticeship.errors.full_messages}" }
        end
      else
        if params[:revoke_button] && current_user.admin? && @apprenticeship.deliver_revoke
         @apprenticeship.revoke
         redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship revoked."}

        elsif params[:reject_button] && current_user.admin? && @apprenticeship.deliver_reject
          @apprenticeship.reject
          redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship rejected." }

        elsif params[:accept_button] && current_user.admin? && @apprenticeship.deliver_accept
          @apprenticeship.accept
          redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship accepted." }

        elsif params[:resubmit_button] && @apprenticeship.deliver_resubmit
          @apprenticeship.resubmit
          redirect_to apprenticeships_path, :flash => { :success => "Thanks! Your apprenticeship was resubmitted."}

        elsif params[:cancel_button] && @apprenticeship.deliver_cancel
          @apprenticeship.cancel
          redirect_to apprenticeships_path, :flash => { :warning => "Rats. Your apprenticeship has been canceled."}
        else
          redirect_to private_apprenticeship_path(@apprenticeship), :flash => { warning: "Please check all fields. You cannot pay until the following have been corrected: #{@apprenticeship.errors.full_messages}" }
        end
      end
    end
  end

  def show
    @apprenticeship = Apprenticeship.find(params[:id])
  end

  def destroy
    @apprenticeship = Apprenticeship.where(:id => params[:id]).first
    @apprenticeship.destroy

    respond_to do |format|
      format.html { redirect_to apprenticeships_path, :flash => { :warning => "Your apprenticeship was deleted."} }
      format.json { head :no_content }
    end
  end

  def info

  end

  def private
     if !@apprenticeship.started?
       if !@apprenticeship.edit_design
        redirect_to apprenticeships_path
       end
     elsif !@apprenticeship.designed
       redirect_to edit_apprenticeship_path(@apprenticeship), flash: { warning: "Please check all fields: #{@apprenticeship.errors.full_messages}" }
     end
  end

  def payment
    if !@apprenticeship.private?
      if !@apprenticeship.edit_design
        redirect_to apprenticeships_path
      elsif @apprenticeship.designed
        redirect_to edit_apprenticeship_path(@apprenticeship), flash: { warning: "Please check all fields: #{@apprenticeship.errors.full_messages}" }
      end
    elsif !@apprenticeship.private_complete
      redirect_to private_apprenticeship_path(@apprenticeship), flash: { warning: "Please check all fields. You cannot pay until the following have been corrected: : #{@apprenticeship.errors.full_messages}" }
    end
    if @apprenticeship.charge_id.present?
      @apprenticeship.paid
    end
  end

  def payment_confirmation
  end

  def cancel
    @apprenticeship.cancel

    respond_to do |format|
      format.html { redirect_to apprenticeships_path, :flash => { :warning => "Your apprenticeship was canceled."} }
      format.json { head :no_content }
    end
  end

  def owner_user
      redirect_to apprenticeships_path unless current_user.admin? || current_user==@apprenticeship.user
  end

  def current_apprenticeship
  	@apprenticeship = Apprenticeship.find_by_id(params[:id])
  	redirect_to :index if @apprenticeship.nil?
    @album = @apprenticeship.host_album
  end

  private
  def load_user_gallery
    @user = current_user
    if @user
      @gallery = @user.gallery
    end
  end

end
