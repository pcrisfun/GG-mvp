class EventsController < ApplicationController

  def index
    @events = Event.where( datetime_tba: false, state: ['accepted','filled','completed']).sort_by { |e| e.created_at }.reverse!
    @tba_events = Event.where( datetime_tba: true, state: ['accepted','filled','completed']).sort_by { |e| e.begins_at }
  end

end