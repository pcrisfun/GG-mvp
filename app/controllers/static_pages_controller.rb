class StaticPagesController < ApplicationController
  def home
    @events = Event.where( datetime_tba: false, state: ['accepted','filled','completed']).limit(4).sort_by { |e| e.created_at }.reverse!
  end

  def faq_makers
  end

  def faq_girls
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
