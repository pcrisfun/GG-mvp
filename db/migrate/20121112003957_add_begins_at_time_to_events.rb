class AddBeginsAtTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :begins_at_time, :datetime
  end
end
