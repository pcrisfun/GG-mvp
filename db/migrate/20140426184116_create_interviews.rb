class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.references :app_signup
      t.references :user
      t.string :interview_time
      t.string :interview_location

      t.timestamps
    end
  end
end
