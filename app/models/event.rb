class Event < ActiveRecord::Base

	belongs_to :user
	validates_presence_of :topic, :host, :description
	attr_accessible :title, :description, :topic, :host, :begins_at, :ends_at, :skill_list, :tool_list, :requirement_list
	before_save :generate_title
	
	acts_as_taggable
	acts_as_taggable_on :skills, :tools, :requirements

	def generate_title
  	self.title = "#{self.topic} Apprenticeship with #{self.host}"
	end
	
	def begins_at=(new_date)
  	write_attribute(:begins_at, Chronic::parse(new_date).strftime('%Y-%m-%d %H:%M:%S'))
	end
	
	def ends_at=(new_date)
  	write_attribute(:ends_at, Chronic::parse(new_date).strftime("%Y-%m-%d %H:%M:%S"))
	end
	
	state_machine :state, :initial => :started do
  	
  	state :started do
  	end
  	
  	state :pending do
  	end
  	
  	state :accepted do
  	end
  	
  	state :canceled do
  	end
  	
  	event :reject do
    	transition :pending => :started
  	end
  	
  	event :revoke do
    	transition :accepted => :started
  	end
  	
  	event :submit do
    	transition :started => :pending
    end
    
    event :accept do
      transition :pending => :accepted
    end
    
    event :cancel do
      transition all => :canceled
    end
    
  end
  	
end
