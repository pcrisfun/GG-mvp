class AddOtherNeedsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :other_needs, :string
  end
end
