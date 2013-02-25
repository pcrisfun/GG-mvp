class WorkSignupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def new
  	@workshop = Workshop.find(params[:workshop_id])
  	@work_signup = WorkSignup.new
  end

  def create
	@workshop = Workshop.find(params[:workshop_id])

  	current_user.update_attributes(params[:user])

    @work_signup = WorkSignup.new(params[:work_signup])
    @work_signup.event_id = @workshop.id
    @work_signup.user_id = current_user.id
    @work_signup.save
  end
end
