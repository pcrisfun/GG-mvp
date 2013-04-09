class PreregsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @prereg = Prereg.find(params[:id])
  end

  def new

    @prereg = Prereg.new
  end

  def create
    @prereg = Prereg.find_or_create_by_user_id_and_event_id(
      :user_id => current_user.id,
      :event_id => params[:event_id])

    respond_to do |format|
      format.json { head :no_content }
    end
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
