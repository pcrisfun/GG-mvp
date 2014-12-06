class AddMakerCityToNominations < ActiveRecord::Migration
  def change
    add_column :nominations, :maker_city, :string
  end
end
