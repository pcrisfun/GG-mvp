class AddParentToSignup < ActiveRecord::Migration
  def change
    add_column :signups, :parent, :string
    add_column :signups, :daughter_firstname, :string
    add_column :signups, :daughter_lastname, :string
    add_column :signups, :daughter_age, :string
  end
end
