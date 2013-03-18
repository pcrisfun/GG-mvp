class RemoveParentFromSignups < ActiveRecord::Migration
  def up
    remove_column :signups, :parent
  end

  def down
    add_column :signups, :parent, :string
  end
end
