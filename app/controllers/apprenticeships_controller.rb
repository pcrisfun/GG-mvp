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
    
    if params[:apprenticeship][:stripe_card_token] && @apprenticeship.save && @apprenticeship.process_payment && @apprenticeship.submit
      flash[:success] = "Your apprenticeship was created!"
      redirect_to apprenticeships_path

    elsif @apprenticeship.save(:validate => false)
      flash[:success] = "Your apprenticeship was saved."
      redirect_to apprenticeships_path

    else
      render new
    end
      
  end

	def update

  	things_are_good = false
	
	  if @apprenticeship.update_attributes(params[:apprenticeship])
            
      if params[:apprenticeship][:stripe_card_token]
        if @apprenticeship.process_payment
          # yay?
        else
          flash.now[:notify] = "Couldn't process payment"
        end
      end
            
      if params[:create_button] || params[:apprenticeship][:stripe_card_token]

        if @apprenticeship.submit
          things_are_good = true
          flash[:success] = "Your apprenticeship was created!"
        end

      elsif params[:revoke_button] && current_user.admin?
        if @apprenticeship.revoke
          things_are_good = true
          flash[:warning] = "Apprenticeship was revoked."
        end
        
      elsif params[:reject_button] && current_user.admin?
        if @apprenticeship.reject
          things_are_good = true
          flash[:warning] = "Apprenticeship was rejected."
        end
        
      elsif params[:accept_button] && current_user.admin?
        if @apprenticeship.accept
          things_are_good = true
          flash[:success] = "Apprenticeship was accepted."
        end

      else
          things_are_good = true
        flash[:success] = "Your apprenticeship was saved."
      end
      
    end

    if things_are_good
      redirect_to apprenticeships_path
      
    else
      flash.now[:notify] = "We couldn't update your apprenticeship. Check your entry!"
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