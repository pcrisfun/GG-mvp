class AddDatetimeTbaToEvents < ActiveRecord::Migration
  def change
    add_column :events, :datetime_tba, :boolean, default: false
  end
end
