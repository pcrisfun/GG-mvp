class PreregsController < ApplicationController
  before_filter :authenticate_user!

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
    flash[:info] = "Thanks! We'll send you an email next time #{prereg.event.host_firstname} is teaching."
    redirect_to prereg.event.is_a?(Workshop) ?
                    workshop_url(params[:event_id]) :
                    apprenticeship_url(params[:event_id])
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
