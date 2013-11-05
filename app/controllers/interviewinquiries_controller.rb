# app/controllers/interviewinquiries_controller.rb

class InterviewinquiriesController < ApplicationController

  def create
    @interviewinquiry = Interviewinquiry.new(params[:interviewinquiry])
    if @interviewinquiry.deliver
      redirect_to scheduleinterview_path, flash: { success: "Sweet! We'll send your applicant(s) your preferred times and let you know when they're available to meet up. We'll let you know as soon as we hear back." }
    else
      render 'static_pages/scheduleinterview'
    end
  end
end