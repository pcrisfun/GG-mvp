class AddReminderSentToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reminder_sent, :boolean, :null => false, :default => false
  end
end
