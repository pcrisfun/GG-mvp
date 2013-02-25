class ApprenticeshipsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :current_apprenticeship, except: [:index, :new, :create]
  before_filter :owner_user, only: [:edit, :update]
  before_filter :current_admin, only: :destroy
  
  def index
    unless current_user.blank?
  	  @mysaved_apprenticeships = current_user.apprenticeships.find_all_by_state('started')
  	  @mypending_apprenticeships = current_user.apprenticeships.find_all_by_state('pending')
  	  @myactive_apprenticeships = current_user.apprenticeships.find_all_by_state('accepted')
      @mycanceled_apprenticeships = current_user.apprenticeships.find_all_by_state('canceled')
      @myinprogress_apprenticeships = current_user.apprenticeships.find_all_by_state('in_progress')
      @mycompleted_apprenticeships = current_user.apprenticeships.find_all_by_state('completed')
      @allpending_apprenticeships = Apprenticeship.find_all_by_state('pending')
      @allsaved_apprenticeships = Apprenticeship.find_all_by_state('started')
      @allcanceled_apprenticeships = Apprenticeship.find_all_by_state('canceled')
      @allinprogress_apprenticeships = Apprenticeship.find_all_by_state('in_progress')
      @allcompleted_apprenticeships = Apprenticeship.find_all_by_state('completed')

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

    if params[:save_button] == "Save for Later"
      if @apprenticeship.group_valid?(:save) && @apprenticeship.save(:validate => false) && @apprenticeship.deliver_save
        redirect_to apprenticeships_path, :flash => { :success => "Nice! Your apprenticeship was saved." }
      else
        flash.now[:warning] = "Whoops! There was a problem saving your apprenticeship. Please check all fields."
        render 'new'
      end
    else
      if @apprenticeship.process_payment
        if @apprenticeship.save
          if @apprenticeship.submit && @apprenticeship.deliver
            redirect_to apprenticeships_path, :flash => {:success => "Baller! Your apprenticeship was submitted!" }
          else
            flash.now[:warning] = "Whoops! There was a problem creating your apprenticeship. Please check all fields."
            render 'edit'
          end
        else
          flash.now[:warning] = "Whoops! There was a problem saving your apprenticeship. Please check all fields."
          render 'new'
        end
      else 
        flash.now[:notify] = "Hmm, we couldn't process payment. Please try again."
        render 'edit'
      end
    end
  end
	
  def update
    if params[:save_button] == "Save for Later"
      if @apprenticeship.group_valid?(:save) && @apprenticeship.update_attributes(params[:apprenticeship],:validate => false)
        redirect_to apprenticeships_path, :flash => { :success => "Your apprenticeship was saved." }
      else
        flash.now[:warning] = "Whoops! There was a problem saving your apprenticeship. Please check all fields."
        render 'edit'
      end

    else
      if @apprenticeship.update_attributes(params[:apprenticeship])

        if params[:revoke_button] && current_user.admin?
          @apprenticeship.revoke
          redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship revoked."}

        elsif params[:reject_button] && current_user.admin?
          @apprenticeship.reject
          redirect_to apprenticeships_path, :flash => { :warning => "Apprenticeship rejected." }
          
        elsif params[:accept_button] && current_user.admin?
          @apprenticeship.accept
          redirect_to apprenticeships_path, :flash => { :success => "Apprenticeship accepted." }

        elsif params[:resubmit_button] && @apprenticeship.deliver_resubmit
          redirect_to apprenticeships_path, :flash => { :success => "Thanks! Your apprenticeship was resubmitted."}

        elsif params[:cancel_button] && @apprenticeship.deliver_cancel
          @apprenticeship.cancel  
          redirect_to apprenticeships_path, :flash => { :warning => "Rats. Your apprenticeship has been canceled."}  

        elsif @apprenticeship.process_payment
          if @apprenticeship.submit && @apprenticeship.deliver
            redirect_to apprenticeships_path, :flash => {:success => "Baller! Your apprenticeship was submitted!" }
          else
            flash[:warning] = "Whoops! Your apprenticeship submission is missing some info. Please check all fields."
            render 'edit'
          end
          
        else
          flash.now[:notify] = "Hmm, we couldn't process payment. Please try again."
          render 'edit'
        end

      else
        flash.now[:warning] = "Whoops! There was a problem saving your apprenticeship. Please check all fields."
        render 'edit'
      end
    end
  end
  
  def show
  end

  def destroy
    @apprenticeship = Apprenticeship.where(:id => params[:id]).first
    @apprenticeship.destroy

    respond_to do |format|
      format.html { redirect_to apprenticeships_path, :flash => { :warning => "Your apprenticeship was deleted."} }
      format.json { head :no_content }
    end
  end
  
  def owner_user
      redirect_to apprenticeships_path unless current_user.admin? || current_user==@apprenticeship.user 
  end
  
  def current_apprenticeship
  	@apprenticeship = Apprenticeship.find_by_id(params[:id])
  	redirect_to :index if @apprenticeship.nil? 
  end
  
end
    