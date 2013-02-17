class AddDatetimeTbaToEvents < ActiveRecord::Migration
  def change
    add_column :events, :datetime_tba, :string
  end
end
