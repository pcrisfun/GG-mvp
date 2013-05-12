class MakersController < ApplicationController
  def show
    @makers = User.joins(:events).where(:events => {:state => ['accepted', 'filled', 'in_progress', 'completed']}).uniq.order("last_name ASC" )
  end
end
