class CreateNominations < ActiveRecord::Migration
  def change
    create_table :nominations do |t|
      t.string :maker_first_name, :maker_last_name, :maker_email, :referrer_first_name, :referrer_last_name

      t.timestamps
    end
  end
end
