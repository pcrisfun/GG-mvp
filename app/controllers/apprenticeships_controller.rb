class ApprenticeshipsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :current_apprenticeship, except: [:index, :new, :create]
  before_filter :owner_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def index
    unless current_user.blank?
  	  @saved_apprenticeships = current_user.apprenticeships.find_all_by_state('started')
  	  @pending_apprenticeships = current_user.apprenticeships.find_all_by_state('pending')
  	  @active_apprenticeships =  current_user.apprenticeships.find_all_by_state('accepted')
    end
  	@apprenticeships = Apprenticeship.find_all_by_state('accepted')
  end
  
  def new
  	@apprenticeship = Apprenticeship.new 
  	@apprenticeship.begins_at = Date.today
  	@apprenticeship.ends_at = Date.today + 1.day
  end	
  
  def create
    @apprenticeship = current_user.apprenticeships.new(params[:apprenticeship])
    if @apprenticeship.save
    
      if params[:apprenticeship][:stripe_card_token].present? 
        if @apprenticeship.process_payment
          if @apprenticeship.submit
            redirect_to apprenticeships_path, :flash => {:success => "Your apprenticeship was created!" }
          else
          flash.now[:warning] = "There was a problem creating your apprenticeship. Please review all fields."
          render 'edit'
          end
        else
          flash.now[:notify] = "Couldn't process payment. There's a problem with def create in the controller."
          render 'edit'
        end
      else
        redirect_to apprenticeships_path, :flash => { :success => "Your apprenticeship was saved." }
      end

    else 
      flash.now[:warning] = "There was a problem saving your apprenticeship. Please review all fields."
      render 'new'
    end
  end
	

  def update
    if @apprenticeship.update_attributes(params[:apprenticeship])
      
      if params[:apprenticeship][:stripe_card_token].present?
        if @apprenticeship.process_payment
          if @apprenticeship.submit
            redirect_to apprenticeships_path, :flash => {:success => "Your apprenticeship was created!" }
          else
            flash[:warning] = "Apprenticeship submission is incomplete. Please review all fields."
            render 'edit'
          end
        else
          flash.now[:notify] = "Couldn't process payment. There's a problem with def update in the controller."
          render 'edit'
        end

      elsif params[:revoke_button] && current_user.admin?
        @apprenticeship.revoke
        redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship was revoked."}

      elsif params[:reject_button] && current_user.admin?
        @apprenticeship.reject
        redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship was rejected." }
        
      elsif params[:accept_button] && current_user.admin?
        @apprenticeship.accept
        redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship was accepted." }

      else
        redirect_to apprenticeships_path, :flash => { :success => "Your apprenticeship was saved." }
      end   

    else
      flash.now[:warning] = "There was a problem saving your apprenticeship. Please review all fields."
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
    