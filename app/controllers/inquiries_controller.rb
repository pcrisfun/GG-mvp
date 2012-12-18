# app/controllers/inquiries_controller.rb

class InquiriesController < ApplicationController

	def create
		@inquiry = Inquiry.new(params[:inquiry])
		if @inquiry.deliver
			render 'static_pages/thanks'
		else
			render 'static_pages/contact'
		end
	end
end