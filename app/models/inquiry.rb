# app/models/inquiry.rb

class Inquiry
	extend ActiveModel::Naming
	include ActiveModel::Conversion
	include ActiveModel::Validations
	include ActionView::Helpers::TextHelper
	
	attr_accessor :name, :email, :message, :nickname
	
	validates_presence_of :name, :message => "Please include your name"
	validates_presence_of :email, :message => "Please include your email"
	validates_presence_of :message, :message => "Please include a message"
	
	validates_format_of :email, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, :message => "Hmmm, think address@example.com"
	
	validates_length_of :message, :minimum => 1, :maximum => 1000

	validates_format_of	:nickname, :with => /^$/
	
	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end
	
	def deliver
		return false unless valid?
		Pony.mail({
			:from => %("#{name}" <#{email}>),
			:reply_to => email,
			:subject => "Website inquiry",
			:body => message,
			:html_body => simple_format(message)
		})
		return true
	end
	
	def persisted?
		false
	end

end