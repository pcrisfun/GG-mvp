class AddPreregIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :prereg_id, :integer
  end
end
