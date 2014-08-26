class AddInterviewIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :interview_id, :integer
  end
end
