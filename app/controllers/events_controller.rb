class EventsController < ApplicationController
  before_filter :current_event, except: [:index]
  before_filter :load_user_gallery

  def index
    @events = Event.find_all_by_state(['accepted','filled','completed'])
  end

  def show
    @event = Event.find(params[:id])
  end

  def current_event
    @event = Event.find(params[:id])
    redirect_to action: :index if @event.nil?
    @album = @event.host_album
  end

  private
  def load_user_gallery
    @user = current_user
    if @user
      @gallery = @user.gallery
    end
  end

end