class AddStateToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :state, :string, :default => "started"
  end
end
