class AddStripeCustomerIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :StripeCustomerId, :integer
  end
end
