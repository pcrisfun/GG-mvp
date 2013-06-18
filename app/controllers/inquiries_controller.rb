# app/controllers/inquiries_controller.rb

class InquiriesController < ApplicationController

	def create
		@inquiry = Inquiry.new(params[:inquiry])
		if @inquiry.deliver
			redirect_to contact_path, flash: { success: "Word. Thanks for sending us an email! We'll get back to you as soon as we possibly can." }
		else
			render 'static_pages/contact'
		end
	end
end