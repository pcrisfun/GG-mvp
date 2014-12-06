class AddWelcomeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome, :boolean, :null => false, :default => false
  end
end
