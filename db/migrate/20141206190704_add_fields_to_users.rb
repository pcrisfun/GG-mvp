class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :city, :string
  	add_column :users, :craft, :string
  	add_column :users, :business_name, :string
  	add_column :users, :learning_interest, :string
  end
end
