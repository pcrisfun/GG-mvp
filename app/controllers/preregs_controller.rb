class PreregsController < ApplicationController

  def show
    @prereg = Prereg.find(params[:id])
  end

  def new
    @event = Event.find(params[:event_id])
    @prereg = Prereg.new
  end

  def create
    @event = Event.find(params[:event_id])
    @prereg = Prereg.new(params[:prereg])
    @prereg.event_id = @event.id
    @prereg.user_id = current_user.id
    current_user.update_attributes(params[:user])
  end

  def destroy
    @prereg = Prereg.find(params[:id])
    @prereg.destroy

    respond_to do |format|
      format.html { redirect_to preregs_url }
      format.json { head :no_content }
    end
  end
end
