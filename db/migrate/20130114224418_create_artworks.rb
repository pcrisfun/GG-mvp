class CreateArtworks < ActiveRecord::Migration
  def change
    create_table :artworks do |t|
      t.string :title
      t.integer :year
      t.string :material
      t.string :category
      t.references :portfolio
      t.references :events

      t.timestamps
    end
  end
end
