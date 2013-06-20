class RemoveFacilitateFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :facilitate
  end

  def down
    add_column :events, :facilitate, :boolean
  end
end
