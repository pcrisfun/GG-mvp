class WorkshopsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :current_workshop, except: [:index, :new, :create]
  before_filter :owner_user, only: [:edit, :update]
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

      @mycompleted_work_signups = current_user.app_signups.find_all_by_state('completed')
    end
  	@workshops = Workshop.find_all_by_state(['accepted','filled','completed'])
  end

  def new
  	@workshop = Workshop.new
  	@workshop.begins_at = Date.today
    @workshop.ends_at = Date.today - 1.day
  end

  def create
    @workshop = current_user.workshops.new(params[:workshop])

    if params[:save_button] == "Save for Later"
      if @workshop.group_valid?(:save) && @workshop.save(:validate => false) && @workshop.deliver_save
        redirect_to workshops_path, :flash => { :success => "Your workshop was saved." }
      else
        flash.now[:warning] = "Whoops! There was a problem saving your workshop. Please check all fields. (Because the save function is messing up!)"
        render 'new'
      end
    else
      if @workshop.save
        if @workshop.submit && @workshop.deliver
          @workshop.host_album  = Album.new(title: "Images for " + @workshop.title_html )
          redirect_to workshops_path, :flash => {:success => "Yatzee! Your workshop was submitted." }
        else
        flash.now[:warning] = "Whoops! There was a problem creating your workshop. Please check all fields."
        render 'edit'
        end
      else
        flash.now[:warning] = "Whoops! There was a problem saving your workshop. Please check all fields."
        render 'new'
      end
    end
  end

  def update
    if params[:save_button] == "Save for Later"
      @workshop.attributes = params[:workshop]
      if @workshop.group_valid?(:save) && @workshop.save(:validate => false)
        redirect_to workshops_path, :flash => { :success => "Nice! Your workshop was saved." }
      else
        flash.now[:warning] = "Whoops! There was a problem saving your workshop. Please check all fields. (Because update is messing up)"
        render 'edit'
      end

    else
      if @workshop.update_attributes(params[:workshop])

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
          redirect_to workshops_path, :flash => { :success => "Thanks! Your workshop was resubmitted."}

        elsif params[:cancel_button] && @workshop.deliver_cancel
          @workshop.cancel
          redirect_to workshops_path, :flash => { :warning => "Rats. Your workshop has been canceled."}

        else @workshop.submit && @workshop.deliver
            redirect_to workshops_path, :flash => {:success => "Yatzee! Your workshop was created!" }
        end

      else
        flash.now[:warning] = "Oops, some required information is missing. Please check all fields."
        render 'edit'
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

  end

  def workshop_album

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
