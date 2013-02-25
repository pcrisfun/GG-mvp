class CreateSignups < ActiveRecord::Migration
  def change

    create_table :signups do |t|
    
      t.references :user
      t.references :event
      t.string :type 
      t.text :happywhen
      t.text :collaborate
      t.text :interest
      t.text :experience
   	  t.text :requirements
	  t.string :confirm_available
	  t.string :preferred_times
	  t.string :confirm_unpaid
	  t.string :confirm_fee
   	  t.string :parent_phone
   	  t.string :parent_name
   	  t.string :parent_email
   	  t.string :waiver
   	  t.string :parents_waiver
   	  t.string :respect_agreement
   	  t.string :charge_id

      t.timestamps
    end
  end
end
