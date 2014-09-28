class AddInterviewMessageToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :interview_message, :text
  end
end
