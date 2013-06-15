class AddAvailabilityToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :availability
    add_column :events, :availability, :text
  end
end
