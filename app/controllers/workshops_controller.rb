class WorkshopsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :current_workshop, except: [:index, :info, :new, :create]
  before_filter :owner_user, only: [:edit, :update, :private, :confirmation]
  before_filter :current_admin, only: :destroy
  before_filter :load_user_gallery

  def index
    unless current_user.blank?
      @mysaved_workshops = current_user.workshops.find_all_by_state('started')
      @mypending_workshops = current_user.workshops.find_all_by_state('pending')
      @myactive_workshops =  current_user.workshops.find_all_by_state('accepted')
      @mycanceled_workshops = current_user.workshops.find_all_by_state('canceled')
      @myfilled_workshops = current_user.workshops.find_all_by_state('filled')
      @mycompleted_workshops = current_user.workshops.find_all_by_state('completed')

      @allsaved_workshops = Workshop.find_all_by_state('started')
      @allpending_workshops = Workshop.find_all_by_state('pending')
      @allcanceled_workshops = Workshop.find_all_by_state('canceled')
      @allfilled_workshops = Workshop.find_all_by_state('filled')
      @allcompleted_workshops = Workshop.find_all_by_state('completed')

      @mysaved_work_signups = current_user.app_signups.find_all_by_state('started')
      @mypending_work_signups = current_user.app_signups.find_all_by_state('pending')
      @myaccepted_work_signups = current_user.app_signups.find_all_by_state('accepted')
      @mycanceled_work_signups = current_user.app_signups.find_all_by_state('canceled')
      @mycompleted_work_signups = current_user.app_signups.find_all_by_state('completed')
      @myconfirmed_work_signups = current_user.app_signups.find_all_by_state('confirmed')
    end
  	@workshops = Workshop.find_all_by_state(['accepted','filled','completed'])
  end

  def new
  	@workshop = Workshop.new
  	@workshop.begins_at = Date.today
    @workshop.ends_at = Date.today - 1.day
  end

  def create
    if params[:workshop]
      @workshop = current_user.workshops.new(params[:workshop])
    else
      @workshop = current_user.workshops.new(topic: 'A New Workshop', host_firstname: current_user.first_name, host_lastname: current_user.last_name, datetime_tba: true)
    end
    @workshop.begins_at ||= Date.today
    @workshop.generate_title

    if @workshop.save(validate: false) && @workshop.deliver_save
      redirect_to edit_workshop_path(@workshop), :flash => { :success => "Nice! Let's Start by designing your workshop." }
    else
      flash.now[:warning] = "Whoops! There was a problem starting your workshop: #{@workshop.errors.full_messages}"
      flash.now[:error] = @workshop.errors.full_messages
      render 'info'
    end
  end

  def update
    if params[:name] && params[:value]
      if @workshop.respond_to?(params[:name])
        if @workshop.xeditable_update(params[:name], params[:value])
          respond_to do |format|
            format.json { render json: {event: @workshop, checkmarks: @workshop.checkmarks} and return }
          end
        else
          respond_to do |format|
              format.json { render json: { errors: @workshop.errors[params[:name].to_sym].first } and return }
          end
        end
      end
    else
      if params[:workshop]
        @workshop.attributes = params[:workshop]
        @workshop.save(validate: false)
        unless @workshop.group_valid?(:design)
          redirect_to edit_workshop_path(@apprenticeship), flash: { warning: "Please correct the following: #{@workshop.errors.full_messages}"} and return
        end
        unless @workshop.group_valid?(:private)
          redirect_to private_workshop_path(@workshop), :flash => { warning: "Please correct the following: #{@workshop.errors.full_messages}" } and return
        end
        @workshop.submit && @workshop.deliver
        redirect_to confirmation_workshop_path(@workshop), flash: { warning: "Awesome! Your Workshop was submitted."}
      else
        if params[:revoke_button] && current_user.admin? && @workshop.deliver_revoke
          @workshop.revoke
          redirect_to workshops_path, :flash => { :warning => "Workshop revoked."}

        elsif params[:reject_button] && current_user.admin? && @workshop.deliver_reject
          @workshop.reject
          redirect_to workshops_path, :flash => { :warning => "Workshop rejected." }

        elsif params[:accept_button] && current_user.admin? && @workshop.deliver_accept
          @workshop.accept
          redirect_to workshops_path, :flash => { :success => "Workshop accepted." }

        elsif params[:resubmit_button] && @workshop.deliver_resubmit
          @workshop.resubmit
          redirect_to workshops_path, :flash => { :success => "Thanks! Your workshop was resubmitted."}

        elsif params[:cancel_button] && @workshop.deliver_cancel
          @workshop.cancel
          redirect_to workshops_path, :flash => { :warning => "Rats. Your workshop has been canceled."}

        else @workshop.submit && @workshop.deliver
            redirect_to workshops_path, :flash => {:success => "Yatzee! Your workshop was created!" }
        end
      end
    end
  end


  def destroy
    @workshop = Workshop.where(:id => params[:id]).first
    @workshop.destroy

    respond_to do |format|
      format.html { redirect_to workshops_path, :flash => { :warning => "Your workshop was deleted."} }
      format.json { head :no_content }
    end
  end

  def cancel
    @workshop = Workshop.where(:id => params[:id]).first
    @workshop.cancel

    respond_to do |format|
      format.html { redirect_to workshops_path, :flash => { :warning => "Your workshop was canceled."} }
      format.json { head :no_content }
    end
  end


  def show
    @workshop = Workshop.find(params[:id])
  end

  def private
  end

  def confirmation
  end

  def checkmarks
    respond_to do |format|
      format.json { render json: @workshop.checkmarks }
    end
  end

  def owner_user
      redirect_to workshops_path unless current_user.admin? || current_user==@workshop.user
  end

  def current_workshop
  	@workshop = Workshop.find(params[:id])
  	redirect_to action: :index if @workshop.nil?
    @album = @workshop.host_album
  end

  private
  def load_user_gallery
    @user = current_user
    if @user
      @gallery = @user.gallery
    end
  end

end
