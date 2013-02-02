class WorkshopsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :current_workshop, except: [:index, :new, :create]
  before_filter :owner_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def index
    unless current_user.blank?
      @mysaved_workshops = current_user.workshops.find_all_by_state('started')
      @mypending_workshops = current_user.workshops.find_all_by_state('pending')
      @myactive_workshops =  current_user.workshops.find_all_by_state('accepted')
      @mycanceled_workshops = current_user.workshops.find_all_by_state('canceled')
      @allpending_workshops = Workshop.find_all_by_state('pending')
      @allsaved_workshops = Workshop.find_all_by_state('started')
      @allcanceled_workshops = Workshop.find_all_by_state('canceled')      
    end
  	@workshops = Workshop.find_all_by_state('accepted')
  end
  
  def new
  	@workshop = Workshop.new 
  	@workshop.begins_at = Date.today
    @workshop.ends_at = Date.today
  end	

  def create
    @workshop = current_user.workshops.new(params[:workshop])
    if @workshop.save
      
      if params[:create_button]
        if @workshop.submit && @workshop.deliver
          redirect_to workshops_path, :flash => {:success => "Your workshop was created!" }
        else
          flash[:warning] = "Workshop submission is incomplete. Please review all fields."
          render 'edit'          
        end
      else
        redirect_to workshops_path, :flash => { :success => "Your workshop was saved." }
      end
    else
      flash.now[:warning] = "There was a problem saving your workshop. Please review all fields."
      render 'new'
    end
  end
  
  def update
    if @workshop.update_attributes(params[:workshop])
      
      if params[:create_button]
        if @workshop.submit && @workshop.deliver
          redirect_to workshops_path, :flash => {:success => "Your workshop was created!" }
        else
          flash[:warning] = "Workshop submission is incomplete. Please review all fields."
          render 'edit'
        end
          
      elsif params[:revoke_button] && current_user.admin?
        @workshop.revoke
        redirect_to workshops_path, :flash => { :warning => "Workshop was revoked." }
          
      elsif params[:reject_button] && current_user.admin?
        @workshop.reject
        redirect_to workshops_path, :flash => { :warning => "Workshop was rejected." }
          
      elsif params[:accept_button] && current_user.admin?
        @workshop.accept
        redirect_to workshops_path, :flash => { :success => "Workshop was accepted." }

      elsif params[:resubmit_button] && @workshop.deliver_resubmit
        redirect_to workshops_path, :flash => { :success => "Your workshop was resubmitted."}

      elsif params[:cancel_button] && @workshop.deliver_cancel
        @workshop.cancel  
        redirect_to workshops_path, :flash => { :warning => "Your workshop has been canceled."}
         
      else
        redirect_to workshops_path, :flash => { :success => "Your workshop was saved." }
      end

    else
      flash.now[:warning] = "There was a problem saving your workshop. Please review all fields."
      render 'edit'
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
  
  
  def show
  end
  
  def owner_user
      redirect_to workshops_path unless current_user.admin? || current_user==@workshop.user 
  end
  
  def current_workshop
  	@workshop = Workshop.find_by_id(params[:id])
  	redirect_to :index if @workshop.nil? 
  end
  
end
