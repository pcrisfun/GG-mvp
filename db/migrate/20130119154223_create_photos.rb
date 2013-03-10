class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :caption
      t.boolean  :protected, :default => false
      t.integer :gallery_id
      t.timestamps
    end
  end
end
