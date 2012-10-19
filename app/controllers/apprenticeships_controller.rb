class ApprenticeshipsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :current_apprenticeship, except: [:index, :new, :create]
  before_filter :owner_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy




	def index
		@apprenticeships = Apprenticeship.all 
	end

	def new
		@apprenticeship = Apprenticeship.new 
	end	

	def create
	    @apprenticeship = current_user.apprenticeships.new(params[:apprenticeship])
	    if @apprenticeship.save
	      flash[:success] = "You created an apprenticeship!"
	      redirect_to apprenticeships_path
	    else
	      render 'new'
	    end
  	end

  	def update
	    if @apprenticeship.update_attributes(params[:apprenticeship])
	      flash[:success] = "Apprenticeship updated"
	      redirect_to apprenticeship_path(@apprenticeship) 
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