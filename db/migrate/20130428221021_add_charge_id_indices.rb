class AddChargeIdIndices < ActiveRecord::Migration
  def up
    add_index :signups, :charge_id
    add_index :events, :charge_id
  end

  def down
    remove_index :signups, :charge_id
    remove_index :events, :charge_id
  end
end
