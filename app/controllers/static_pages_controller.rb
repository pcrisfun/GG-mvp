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
end
