class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user
      t.string :type
      t.string :state, :default => "started"
      t.string :title
      t.string :topic
      t.string :host_firstname
      t.string :host_lastname
      t.string :host_business
      t.text :bio
      t.string :twitter
      t.string :facebook
      t.string :website
      t.string :webshop
      t.string :permission
      t.string :payment_options
      t.string :paypal_email
      t.string :sendcheck_address
      t.string :sendcheck_address2
      t.string :sendcheck_city
      t.string :sendcheck_state
      t.string :sendcheck_zip
      t.text :description
      t.date :begins_at, :null => true
      t.date :ends_at, :null => true
      t.integer :hours
      t.string :hours_per, :default => "week"
      t.string :availability
      t.string :location_address
      t.string :location_address2
      t.string :location_city
      t.string :location_state
      t.string :location_zipcode
      t.boolean :location_private, :boolean, :default => true
      t.boolean :location_varies, :boolean, :default => false
      t.integer :age_min
      t.integer :age_max
      t.integer :registration_min
      t.integer :registration_max
      t.timestamps
    end
  end
end
