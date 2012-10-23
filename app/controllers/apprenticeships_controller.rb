class ApprenticeshipsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :current_apprenticeship, except: [:index, :new, :create]
  before_filter :owner_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def index
  	@saved_apprenticeships = current_user.apprenticeships.find_all_by_state('started')
  	@pending_apprenticeships = current_user.apprenticeships.find_all_by_state('pending')
  	@active_apprenticeships =  current_user.apprenticeships.find_all_by_state('accepted')
  	@apprenticeships = Apprenticeship.find_all_by_state('accepted')
  end
  
  def new
  	@apprenticeship = Apprenticeship.new 
  	@apprenticeship.begins_at = Date.today
  	@apprenticeship.ends_at = Date.today + 1.day
  end	
  
  def create
      @apprenticeship = current_user.apprenticeships.new(params[:apprenticeship])
      if @apprenticeship.save!
      
        if params[:create_button]
          @apprenticeship.submit
          flash[:success] = "Your apprenticeship was created!"

        else
          flash[:success] = "Your apprenticeship was saved."
        end
        
        redirect_to apprenticeships_path
      else
        render 'new'
      end
  	end
  
  	def update
      if @apprenticeship.update_attributes(params[:apprenticeship])
      
        if params[:create_button]
          @apprenticeship.submit
          flash[:success] = "Your apprenticeship was created!"
          
        elsif params[:revoke_button] && current_user.admin?
          @apprenticeship.revoke
          flash[:warning] = "Apprenticeship was revoked."
          
        elsif params[:reject_button] && current_user.admin?
          @apprenticeship.reject
          flash[:warning] = "Apprenticeship was rejected."
          
        elsif params[:accept_button] && current_user.admin?
          @apprenticeship.accept
          flash[:success] = "Apprenticeship was accepted."
          
        else
          flash[:success] = "Your apprenticeship was saved."
        end
        redirect_to apprenticeships_path
      else
        render 'edit'
      end
  	end
  
  
  def show
  end
  
  def owner_user
      redirect_to apprenticeships_path unless current_user.admin? || current_user==@apprenticeship.user 
  end
  
  def current_apprenticeship
  	@apprenticeship = Apprenticeship.find_by_id(params[:id])
  	redirect_to :index if @apprenticeship.nil? 
  end
end