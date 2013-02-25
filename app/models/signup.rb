class Signup < ActiveRecord::Base
  
	belongs_to :user
	belongs_to :event

	attr_accessible :collaborate, :happywhen, :interest, :experience, :requirements, :confirm_available, :preferred_times, :confirm_unpaid, :confirm_fee, :parent_phone, :parent_name, :parent_email, :waiver, :parents_waiver, :respect_agreement, :charge_id

end
