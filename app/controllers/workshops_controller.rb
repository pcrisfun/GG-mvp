class WorkshopsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :current_workshop, except: [:index, :info, :new, :create]
  before_filter :owner_user, only: [:edit, :update, :private, :confirmation]
  before_filter :current_admin, only: :destroy
  before_filter :load_user_gallery

  def index
    unless current_user.blank?
      @allsaved_workshops = Workshop.find_all_by_state('started')
      @allpending_workshops = Workshop.find_all_by_state('pending')
      @allcanceled_workshops = Workshop.find_all_by_state('canceled')
      @allfilled_workshops = Workshop.find_all_by_state('filled')
      @allcompleted_workshops = Workshop.find_all_by_state('completed')
    end
  	@workshops = Workshop.find_all_by_state(['accepted','filled','completed'])
  end

  def new
  	@workshop = Workshop.new
  	@workshop.begins_at = Date.today
    @workshop.ends_at = Date.today - 1.day
  end



#---- create
  def create
    if params[:workshop]
      @workshop = current_user.workshops.new(params[:workshop])
    else
      @workshop = current_user.workshops.new(topic: 'A New Workshop', host_firstname: current_user.first_name, host_lastname: current_user.last_name, datetime_tba: true, location_state: "TX", location_city: "Austin")
    end
    @workshop.begins_at ||= Date.today
    @workshop.generate_title

    if @workshop.save(validate: false) && @workshop.deliver_save
      redirect_to edit_workshop_path(@workshop), :flash => { :success => "Nice! Let's start by designing your workshop. We'll save this form as you go so you can come back to it at any time." }
    else
      raise
    end
  rescue
    error_msg = " "
    @workshop.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Fudge.  The following error(s) occured while attempting to create your workshop: #{error_msg}".html_safe} and return
  end

#---- update
  def update
    if params[:name] && params[:value]
      if @workshop.respond_to?(params[:name])
        if @workshop.xeditable_update(params[:name], params[:value])
          respond_to do |format|
            # format.html { redirect_to @workshop, notice: "Success!" }
            format.json { render json: {event: @workshop, checkmarks: @workshop.checkmarks} and return }
          end
        else
          respond_to do |format|
              # format.html { render :edit }
              format.json { render json: { errors: @workshop.errors[params[:name].to_sym].first } and return }
          end
        end
      end
    else
      if params[:workshop]
        @workshop.attributes = params[:workshop]
        @workshop.save(validate: false)

        if params[:revoke_button]
          if current_user.admin? && @workshop.revoke && @workshop.deliver_revoke
            redirect_to workshops_path, :flash => { :warning => "Workshop revoked."}
          end

        elsif params[:reject_button]
          if current_user.admin? && @workshop.reject && @workshop.deliver_reject
            redirect_to workshops_path, :flash => { :warning => "Workshop rejected." }
          end

        elsif params[:commit] == 'Save'
          redirect_to :back, flash: { success: "Your workshop has been saved"} and return

        elsif !@workshop.group_valid?(:design)
          redirect_to edit_workshop_path(@workshop), flash: { warning: "Please correct the following: #{@workshop.errors.full_messages}"} and return

        elsif !@workshop.group_valid?(:private)
          redirect_to private_workshop_path(@workshop), :flash => { warning: "Please correct the following: #{@workshop.errors.full_messages}" } and return

        else
          @workshop.submit && @workshop.deliver
          redirect_to confirmation_workshop_path(@workshop), flash: { success: "Awesome! Your workshop was submitted."} and return
        end
        raise
      end
    end
  rescue
    error_msg = " "
    @workshop.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Fudge.  The following error(s) occured while attempting to update your workshop: #{error_msg}".html_safe} and return
  end

#---- destroy
  def destroy
    @workshop = Workshop.where(:id => params[:id]).first
    if @workshop.verify_delete?
      @workshop.destroy
      redirect_to workshops_path, :flash => { :warning => "Your workshop was deleted."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @workshop.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Fudge.  The following error(s) occured while attempting to delete your workshop: #{error_msg}".html_safe} and return
  end

#---- cancel
  def cancel
    @workshop = Workshop.where(:id => params[:id]).first
    @workshop.signups.each {|s| s.cancel && s.deliver_cancel }
    if @workshop.cancel && @workshop.deliver_cancel
      redirect_to workshops_path, :flash => { :warning => "Rats. Your workshop has been canceled."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @workshop.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Fudge.  The following error(s) occured while attempting to cancel your workshop: #{error_msg}".html_safe} and return
  end

#---- accept
  def accept
    if @workshop.accept && @workshop.deliver_accept
      redirect_to workshops_path, :flash => { :success => "Workshop accepted." } and return
    else
      raise
    end
  rescue
    error_msg = " "
    @workshop.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Fudge.  The following error(s) occured while attempting to accept your workshop: #{error_msg}".html_safe} and return
  end

#---- resubmit
  def resubmit
    if @workshop.resubmit && @workshop.deliver_resubmit
      redirect_to workshops_path, :flash => { :success => "Thanks! Your workshop was resubmitted. We'll look it over and let you know when it's posted."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @workshop.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Fudge.  The following error(s) occured while attempting to resubmit your workshop: #{error_msg}".html_safe} and return
  end

#---- reject
  #def reject
    #@workshop.reject && @workshop.deliver_reject
    #redirect_to workshops_path, :flash => { :warning => "Workshop rejected." } and return
  #end

#---- revoke
  #def revoke
    #@workshop.revoke && @workshop.deliver_revoke
    #redirect_to workshops_path, :flash => { :warning => "Workshop revoked."} and return
  #end


  def show
    @workshop = Workshop.find(params[:id])
  end

  def private
    unless @workshop.group_valid?(:design)
      redirect_to edit_workshop_path(@workshop), flash: { warning: "Please correct the following: #{@workshop.errors.full_messages}"} and return
    end
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
