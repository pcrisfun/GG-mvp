class AddCouponToEvents < ActiveRecord::Migration
  def change
    add_column :events, :coupon, :string
  end
end
