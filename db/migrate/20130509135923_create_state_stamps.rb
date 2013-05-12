class CreateStateStamps < ActiveRecord::Migration
  def change
    create_table :state_stamps do |t|
      t.string :state
      t.date :stamp
      t.integer :event_id
      t.integer :signup_id

      t.timestamps
    end
  end
end
