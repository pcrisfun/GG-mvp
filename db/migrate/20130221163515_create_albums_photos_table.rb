class CreateAlbumsPhotosTable < ActiveRecord::Migration
  def up
  	create_table :albums_photos, :id => false do |t|
      t.references :album
      t.references :photo
    end
    add_index :albums_photos, [:album_id, :photo_id]
    add_index :albums_photos, [:photo_id, :album_id]
  end

  def down
  	drop_table :albums_photos
  end
end
