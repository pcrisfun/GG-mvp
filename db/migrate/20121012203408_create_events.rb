class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user
      t.string :type
      t.string :state, :default => "started"
      t.boolean :kind
      t.string :title
      t.string :topic
      t.string :host
      t.text :description
      t.datetime :begins_at, :null => true
      t.datetime :ends_at, :null => true
      t.integer :hours
      t.string :hours_per, :default => "week"
      t.string :availability
      t.datetime :registration_ends_at
      t.string :location_address
      t.string :location_address2
      t.string :location_city
      t.string :location_state
      t.string :location_zipcode
      t.boolean :location_private
      t.boolean :location_varies
      t.integer :age_min
      t.integer :age_max
      t.integer :registration_min
      t.integer :registration_max
      t.timestamps
    end
  end
end
