class AddEndsAtDateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ends_at_date, :date
  end
end
