class Event < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :title, :description
	attr_accessible :title, :description, :topic, :host
end
