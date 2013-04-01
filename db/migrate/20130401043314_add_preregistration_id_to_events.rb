class AddPreregistrationIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :preregistration_id, :integer
  end
end
