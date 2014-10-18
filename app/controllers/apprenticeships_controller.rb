class ApprenticeshipsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show, :new]
  before_filter :current_apprenticeship, except: [:index, :new, :create, :save, :duplicate]
  before_filter :owner_user, only: [:edit, :private, :payment, :payment_confirmation, :update]
  before_filter :current_admin, only: :destroy
  before_filter :load_user_gallery

  def index
    unless current_user.blank?
      @allsaved_apprenticeships = Apprenticeship.find_all_by_state('started').sort_by { |e| e.begins_at }
      @allpending_apprenticeships = Apprenticeship.find_all_by_state('pending').sort_by { |e| e.begins_at }
      @allcanceled_apprenticeships = Apprenticeship.find_all_by_state('canceled').sort_by { |e| e.begins_at }
      @allfilled_apprenticeships = Apprenticeship.find_all_by_state('filled').sort_by { |e| e.begins_at }
      @allcompleted_apprenticeships = Apprenticeship.find_all_by_state('completed').sort_by { |e| e.begins_at }
    end
    @apprenticeships = Apprenticeship.where( datetime_tba: false, state: ['accepted']).sort_by { |e| e.created_at }.reverse!
    @tba_apprenticeships = Apprenticeship.where( datetime_tba: true, state: ['accepted']).sort_by { |e| e.created_at }
    @closed_apprenticeships = Apprenticeship.where( datetime_tba: false, state: ['filled','completed']).where("begins_at < :today", {today: Date.today}).sort_by { |e| e.begins_at }.reverse!

  end

  def new
  end



#---- create
  def create
    if params[:apprenticeship]
      @apprenticeship = current_user.apprenticeships.new(params[:apprenticeship])
    else
      @apprenticeship = current_user.apprenticeships.new(topic: 'Your Apprenticeship Topic', host_firstname: current_user.first_name, host_lastname: current_user.last_name, kind: "In-House", datetime_tba: false, hours: "8", availability: "On a flexible schedule", location_private: false, location_address: "1309 Chestnut Ave.", location_state: "TX", location_city: "Austin", location_nbrhood: "East Austin", location_zipcode: "78702", age_min: "12", age_max: "100", registration_max: "1")
    end
    @apprenticeship.begins_at ||= Date.today + 7.day
    @apprenticeship.ends_at ||= Date.tomorrow + 97.day
    @apprenticeship.generate_title

    if @apprenticeship.save(validate: false) && @apprenticeship.deliver_save
      redirect_to edit_apprenticeship_path(@apprenticeship)#, :flash => { :success => "Nice! Let's start by designing your apprenticeship. Click on the text to edit, and hover on the blue question marks for more info. We'll save this form as you go so you can come back to it at any time." }
    else
      raise
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    respond_to do |format|
      format.json { render json: { errors: $!.inspect } and return }
      format.html { redirect_to :back, :flash => { warning: "Blarf.  The following error(s) occured while attempting to create your apprenticeship: #{error_msg}".html_safe} and return }
    end

  end

#---- update
  def update
    if params[:name] && params[:value]
      if @apprenticeship.respond_to?(params[:name])
        if @apprenticeship.xeditable_update(params[:name], params[:value])
          respond_to do |format|
            format.json { render json: {event: @apprenticeship, checkmarks: @apprenticeship.checkmarks } and return }
          end
        else
          respond_to do |format|
              format.json { render json: { errors: @apprenticeship.errors[params[:name].to_sym].first } and return }
          end
        end
      end
    else
      if params[:apprenticeship]
        @apprenticeship.attributes = params[:apprenticeship]
        @apprenticeship.save(validate: false)

        if params[:revoke_button]
          if current_user.admin? && @apprenticeship.revoke && @apprenticeship.deliver_revoke
            redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship revoked."} and return
          end

        elsif params[:reject_button]
          if current_user.admin? && @apprenticeship.reject && @apprenticeship.deliver_reject
            redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship rejected." } and return
          end

        # add syntax like the above for the :close_button
          # add logic to change state from "accepted" to "filled" (see events.rb model for state_machine logic)
          # add redirect_back with flash message "Your apprenticeship is closed for applications"

        elsif params[:commit] == 'Save'
          redirect_to :back, flash: { success: "Your apprenticeship has been saved"} and return

        elsif params[:apprenticeship][:stripe_card_token] && ( params[:apprenticeship][:stripe_card_token] != "" )
          if @apprenticeship.process_payment
            @apprenticeship.paid
            @apprenticeship.deliver
            redirect_to payment_confirmation_apprenticeship_path(@apprenticeship) and return
          else
            Rails.logger.info("This will end up in papertrail: #{current_user} ")
            Rollbar.report_exception({:error_message => 'Apprenticeship Payment Failed'}, rollbar_request_data, rollbar_person_data)
            redirect_to payment_apprenticeship_path(@apprenticeship), :flash => { warning: "There was a problem processing your payment: #{@apprenticeship.errors.full_messages}" } and return
          end
        else
          redirect_to payment_apprenticeship_path(@apprenticeship) and return
        end
        raise
      end
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Blarf.  The following error(s) occured while attempting to update your apprenticeship: #{error_msg}".html_safe} and return
  end

#---- destroy
  def destroy
    @apprenticeship = Apprenticeship.where(:id => params[:id]).first
    if @apprenticeship.verify_delete?
      @apprenticeship.destroy
      redirect_to apprenticeships_path, :flash => { :warning => "Your apprenticeship was deleted."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Blarf.  The following error(s) occured while attempting to delete your apprenticeship: #{error_msg}".html_safe} and return
  end

#---- cancel
  def cancel
    @apprenticeship = Apprenticeship.where(:id => params[:id]).first
    @apprenticeship.signups.each do |s|
      s.cancel && s.deliver_cancel_bymaker

      Prereg.find_or_create_by_user_id_and_event_id!(
        :user_id => s.user_id,
        :event_id => @apprenticeship.id)
    end
    if @apprenticeship.cancel && @apprenticeship.deliver_cancel
      redirect_to apprenticeships_path, :flash => { :warning => "Rats. Your apprenticeship has been canceled."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Blarf.  The following error(s) occured while attempting to cancel your apprenticeship: #{error_msg}".html_safe} and return
  end
#---- close
  def close
    if @apprenticeship.fill && @apprenticeship.deliver_close
      redirect_to :back, :flash => { :warning => "Your apprenticeship was closed for applications."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Whoops, the following error(s) occured while attempting to close your apprenticeship: #{error_msg}".html_safe} and return
  end
#---- reopen
  def reopen
    if @apprenticeship.reopen && @apprenticeship.deliver_reopen
      redirect_to :back, :flash => {:success => "Great! Your apprenticeship is open for applications again."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Whoops, the following error(s) occured while attempting to reopen your apprenticeship: #{error_msg}".html_safe} and return
  end
#---- accept
  def accept
    if @apprenticeship.accept && @apprenticeship.deliver_accept
      redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship accepted." } and return
    else
      raise
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Blarf.  The following error(s) occured while attempting to accept your apprenticeship: #{error_msg}".html_safe} and return
  end

#---- resubmit
  def resubmit
    if @apprenticeship.resubmit && @apprenticeship.deliver_resubmit
      redirect_to apprenticeships_path, :flash => { :success => "Thanks! Your apprenticeship was resubmitted. We'll take a look at it and let you know when it's posted."} and return
    else
      raise
    end
  rescue
    error_msg = " "
    @apprenticeship.errors.each do |field, msg|
      error_msg << "<br/>"
      error_msg << msg
    end
    redirect_to :back, :flash => { warning: "Blarf.  The following error(s) occured while attempting to resubmit your apprenticeship: #{error_msg}".html_safe} and return
  end

#---- reject
  #def reject
    #@apprenticeship.reject && @apprenticeship.deliver_reject
    #redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship rejected." } and return
  #end

#---- revoke
  #def revoke
    #@apprenticeship.revoke && @apprenticeship.deliver_revoke
    #redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship revoked."} and return
  #end

  def set_featured_listing
    @apprenticeship.toggle!(:featured) and return
  end

  def show
    @apprenticeship = Apprenticeship.find(params[:id])
    if current_user && !@apprenticeship.signups.empty?
      @app_signup = @apprenticeship.signups.where(user_id: current_user.id).first
    end
  end

  def duplicate
      old_apprenticeship = Apprenticeship.find(params[:id])
      maker = old_apprenticeship.user
      @apprenticeship = maker.apprenticeships.new( title: old_apprenticeship.title,
                                             topic: old_apprenticeship.topic,
                                             kind: old_apprenticeship.kind,
                                             availability: old_apprenticeship.availability,
                                             host_firstname: old_apprenticeship.host_firstname,
                                             host_lastname: old_apprenticeship.host_lastname,
                                             host_business: old_apprenticeship.host_business,
                                             description: old_apprenticeship.description,
                                             hours: old_apprenticeship.hours,
                                             location_private: old_apprenticeship.location_private,
                                             location_nbrhood: old_apprenticeship.location_nbrhood,
                                             location_address: old_apprenticeship.location_address,
                                             location_city: old_apprenticeship.location_city,
                                             location_state: old_apprenticeship.location_state,
                                             location_zipcode: old_apprenticeship.location_zipcode,
                                             gender: old_apprenticeship.gender,
                                             age_min: old_apprenticeship.age_min,
                                             age_max: old_apprenticeship.age_max,
                                             registration_max: old_apprenticeship.registration_max,
                                             skill_list: old_apprenticeship.skill_list,
                                             tool_list: old_apprenticeship.tool_list,
                                             requirement_list: old_apprenticeship.requirement_list
                                            )

      @apprenticeship.begins_at ||= Date.today + 7.day
      @apprenticeship.ends_at ||= Date.tomorrow + 97.day

      if @apprenticeship.save(validate: false) && @apprenticeship.deliver_duplicate
        redirect_to edit_apprenticeship_path(@apprenticeship)#, :flash => { :success => "Nice! Let's start by designing your apprenticeship. Click on the text to edit, and hover on the blue question marks for more info. We'll save this form as you go so you can come back to it at any time." }
      else
        raise
      end
    rescue
      error_msg = " "
      @apprenticeship.errors.each do |field, msg|
        error_msg << "<br/>"
        error_msg << msg
      end
      respond_to do |format|
        format.json { render json: { errors: $!.inspect } and return }
        format.html { redirect_to :back, :flash => { warning: "Blarf.  The following error(s) occured while attempting to duplicate your apprenticeship: #{error_msg}. Try creating a new apprenticeship from scratch.".html_safe} and return }
      end
  end

  def private
    unless @apprenticeship.group_valid?(:design)
      redirect_to edit_apprenticeship_path(@apprenticeship), flash: { warning: "Please correct the following: #{@apprenticeship.errors.full_messages}"} and return
    end
  end

  def payment
    unless @apprenticeship.group_valid?(:design)
      redirect_to edit_apprenticeship_path(@apprenticeship), flash: { warning: "Before you pay, please correct the following: #{@apprenticeship.errors.full_messages}"} and return
    end
    unless @apprenticeship.group_valid?(:private)
      redirect_to private_apprenticeship_path(@apprenticeship), :flash => { warning: "Before you pay, please correct the following: #{@apprenticeship.errors.full_messages}" } and return
    end
  end

  def payment_confirmation
  end

  def checkmarks
    respond_to do |format|
      format.json { render json: @apprenticeship.checkmarks }
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
