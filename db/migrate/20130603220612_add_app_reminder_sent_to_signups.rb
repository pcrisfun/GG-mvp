class AddAppReminderSentToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :app_reminder_sent, :boolean, :null => false, :default => false
    add_column :signups, :app_followup_sent, :boolean, :null => false, :default => false
    add_column :signups, :app_followup_maker_sent, :boolean, :null => false, :default => false
    add_column :signups, :work_first_reminder_sent, :boolean, :null => false, :default => false
    add_column :signups, :work_second_reminder_sent, :boolean, :null => false, :default => false
    add_column :signups, :work_followup_sent, :boolean, :null => false, :default => false
  end
end
