class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :StripeCustomerId, :stripe_customer_id
  end
end
