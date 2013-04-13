class CreatePreregs < ActiveRecord::Migration
  def change
    create_table :preregs do |t|
      t.integer :event_id
      t.references :user
      t.timestamps
    end

    add_index :preregs, [:event_id, :user_id], :unique => true
  end
end
