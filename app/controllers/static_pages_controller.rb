class StaticPagesController < ApplicationController
  def home
     @events = Event.where( datetime_tba: false, state: ['accepted']).where("begins_at >= :recent", {recent: Date.today-30.days}).sort_by { |e| e.begins_at }.reverse!.take(4)
     @tba_events = Event.where( datetime_tba: true, state: ['accepted','filled','completed']).limit(4 - @events.count).sort_by { |e| e.created_at }
    #@events = Event.where( state: ['accepted','filled','completed']).where("begins_at >= :today", {today: Date.today}).limit(4).sort_by { |e| e.begins_at }
    #@events = Event.where( state: ['accepted']).limit(4).sort_by { |e| e.created_at }.reverse!
  end

  def faq
  end

  def about
  end

  def contact
    @inquiry = Inquiry.new
  end

  def newsletter
  end

  def thankyou
  end

  def termsandconditions
  end

  def privacypolicy
  end

  def copyrightpolicy
  end

  def get_involved_makers
  end

  def get_involved_girls
  end


end
