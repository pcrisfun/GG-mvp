class AddRespectMyStyleToEvents < ActiveRecord::Migration
  def change
    add_column :events, :respect_my_style, :string
  end
end
