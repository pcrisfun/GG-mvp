class AddLegalNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :legal_name, :string
  end
end
