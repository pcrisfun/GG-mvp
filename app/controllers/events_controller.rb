class EventsController < ApplicationController

  def index
    @events = Event.where( datetime_tba: false, state: ['accepted']).sort_by { |e| e.begins_at }
    @tba_events = Event.where( datetime_tba: true, state: ['accepted']).sort_by { |e| e.created_at }
    @closed_events = Event.where( datetime_tba: false, state: ['filled','completed']).where("begins_at < :today", {today: Date.today}).sort_by { |e| e.begins_at }.reverse!
  end

end