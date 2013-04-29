class AddGenderToEvents < ActiveRecord::Migration
  def change
    add_column :events, :gender, :boolean, :default => false
  end
end
