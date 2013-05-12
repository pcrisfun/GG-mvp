class StateStamp < ActiveRecord::Base
  attr_accessible :stamp, :state, :event_id, :signup_id
end
