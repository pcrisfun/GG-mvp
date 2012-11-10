class WorkshopsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :current_workshop, except: [:index, :new, :create]
  before_filter :owner_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def index
    unless current_user.blank?
      @saved_workshops = current_user.workshops.find_all_by_state('started')
      @pending_workshops = current_user.workshops.find_all_by_state('pending')
      @active_workshops =  current_user.workshops.find_all_by_state('accepted')
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
      if @workshop.save!
      
        if params[:create_button]
          @workshop.submit
          flash[:success] = "Your workshop was created!"

        else
          flash[:success] = "Your workshop was saved."
        end
        
        redirect_to workshops_path
      else
        render 'new'
      end
  	end
  
  	def update
      if @workshop.update_attributes(params[:workshop])
      
        if params[:create_button]
          @workshop.submit
          flash[:success] = "Your workshop was created!"
          
        elsif params[:revoke_button] && current_user.admin?
          @workshop.revoke
          flash[:warning] = "Workshop was revoked."
          
        elsif params[:reject_button] && current_user.admin?
          @workshop.reject
          flash[:warning] = "Workshop was rejected."
          
        elsif params[:accept_button] && current_user.admin?
          @workshop.accept
          flash[:success] = "Workshop was accepted."
          
        else
          flash[:success] = "Your workshop was saved."
        end
        redirect_to workshops_path
      else
        render 'edit'
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