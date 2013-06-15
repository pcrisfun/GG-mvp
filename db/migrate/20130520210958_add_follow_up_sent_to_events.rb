class AddFollowUpSentToEvents < ActiveRecord::Migration
  def change
    add_column :events, :follow_up_sent, :boolean, :null => false, :default => false
  end
end
