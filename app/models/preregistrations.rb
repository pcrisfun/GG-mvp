class Preregistrations < ActiveRecord::Base

  belongs_to :user
  belongs_to :maker, :class_name => "User", :foreign_key => "maker_id"
  has_one :event

  attr_accessible :maker_id, :event_id, :user_id

end
