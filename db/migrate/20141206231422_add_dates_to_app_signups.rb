class AddDatesToAppSignups < ActiveRecord::Migration
  def change
  	add_column :signups, :start_date, :datetime
  	add_column :signups, :end_date, :datetime
  end
end
