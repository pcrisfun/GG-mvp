class AddFollowUpSentToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :follow_up_sent, :boolean, :null => false, :default => false
  end
end
