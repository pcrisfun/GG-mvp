class PreregsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @prereg = Prereg.find(params[:id])
  end

  def new
    @prereg = Prereg.new
  end

  def create
    prereg = Prereg.find_or_create_by_user_id_and_event_id!(
      :user_id => current_user.id,
      :event_id => params[:event_id])

    prereg.deliver_prereg
    flash[:success] = "Thanks! We'll send you an email when #{prereg.event.host_firstname} has set a new date for #{prereg.event.topic}."
    redirect_to prereg.event.is_a?(Workshop) ?
                    workshop_url(params[:event_id]) :
                    apprenticeship_url(params[:event_id])
  end

  def destroy
    @prereg = Prereg.find(params[:id])
    @event = @prereg.event
    @prereg.destroy
    flash[:warning] = "You have successfully unfollowed #{@event.title}."
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end