class ChangeMakerChargeIdOnSignups < ActiveRecord::Migration
  def up
    change_column :signups, :maker_charge_id, :string
  end

  def down
  end
end
