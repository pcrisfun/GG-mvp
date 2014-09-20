class ChangeSignuptextfieldsToLimitnil < ActiveRecord::Migration
  def up
    change_column :signups, :happywhen, :text, :limit => nil
    change_column :signups, :collaborate, :text, :limit => nil
    change_column :signups, :interest, :text, :limit => nil
    change_column :signups, :experience, :text, :limit => nil
    change_column :signups, :preferred_times, :text, :limit => nil
  end

  def down
  end
end
