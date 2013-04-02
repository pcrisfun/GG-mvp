class CreatePreregs < ActiveRecord::Migration
  def change
    create_table :preregs do |t|
      t.integer :event_id
      t.integer :maker_id
      t.references :user
      t.timestamps
    end
  end
end
