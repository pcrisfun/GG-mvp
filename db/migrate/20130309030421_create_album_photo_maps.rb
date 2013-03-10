class CreateAlbumPhotoMaps < ActiveRecord::Migration
  def change
    create_table :album_photo_maps do |t|
      t.integer :album_id
      t.integer :photo_id
      t.integer :position
      t.boolean :featured

      t.timestamps
    end
  end
end
