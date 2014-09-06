class AddMakerChargeIdToSignup < ActiveRecord::Migration
  def change
    add_column :signups, :maker_charge_id, :integer
  end
end
