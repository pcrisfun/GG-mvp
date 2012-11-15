class AddLocationNbrhoodToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location_nbrhood, :string
  end
end
