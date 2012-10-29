class AddChargeIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :charge_id, :string
  end
end
