class EventsController < ApplicationController

  def index
    @events = Event.where( datetime_tba: false, state: ['accepted']).sort_by { |e| e.created_at }
    @tba_events = Event.where( datetime_tba: true, state: ['accepted']).sort_by { |e| e.created_at }
    @filled_events = Event.where( datetime_tba: false, state: ['filled']).sort_by { |e| e.begins_at }.reverse!
    @closed_events = Event.where( datetime_tba: false, state: ['completed']).sort_by { |e| e.begins_at }.reverse!
  end

end