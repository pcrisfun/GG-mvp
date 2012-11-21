class AddEndsAtTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ends_at_time, :time
  end
end
