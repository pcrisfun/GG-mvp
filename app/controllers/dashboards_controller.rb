class DashboardsController < ApplicationController

  before_filter :authenticate_user!

  def display
    if current_user
      @events = current_user.events
      @signups = current_user.signups
    end

  end

end