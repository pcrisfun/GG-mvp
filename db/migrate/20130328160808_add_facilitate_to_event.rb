class AddFacilitateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :facilitate, :boolean
  end
end
