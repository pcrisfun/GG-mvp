class AddBeginsAtDateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :begins_at_date, :datetime
  end
end
