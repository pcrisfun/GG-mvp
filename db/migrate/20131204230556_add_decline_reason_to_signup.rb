class AddDeclineReasonToSignup < ActiveRecord::Migration
  def change
    add_column :signups, :decline_reason, :text
  end
end
