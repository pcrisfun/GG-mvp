class AddLimitToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :limit, :integer
  end
end
