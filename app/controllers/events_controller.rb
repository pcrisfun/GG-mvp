class EventsController < ApplicationController

  def index
    @events = Event.where( state: ['accepted','filled','completed']).sort_by { |e| e.created_at }.reverse!
  end

end