class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.integer :gallery_id
      t.integer :event_id
      t.timestamps
    end
  end
end
