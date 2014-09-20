class ChangeStripeCustomerIdInUsers < ActiveRecord::Migration
  def up
    change_column :users, :stripe_customer_id, :string
  end

  def down
  end
end
