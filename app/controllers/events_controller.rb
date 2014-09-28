class EventsController < ApplicationController

  def index
    @events = Event.where( datetime_tba: false, state: ['accepted']).sort_by { |e| e.created_at }.reverse!
    @tba_events = Event.where( datetime_tba: true, state: ['accepted']).sort_by { |e| e.created_at }
    @filled_events = Event.where( datetime_tba: false, state: ['filled']).sort_by { |e| e.begins_at }.reverse!
    @closed_events = Event.where( datetime_tba: false, state: ['completed']).sort_by { |e| e.begins_at }.reverse!
  end

  #Does this need to be in the Apprent / Workshop controllers because of the routes?
  def set_featured_listing
    @event = Event.find(params[:id])
    @event.toggle!(:featured)
    # respond_to do |format|
    #   format.js { render 'events/add_featured' }
    # end
  end

end