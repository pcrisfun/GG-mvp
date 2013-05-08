class StaticPagesController < ApplicationController
  def home
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

  def get_involved
  end
end
