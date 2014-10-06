class AddPersonalContactToAppSignups < ActiveRecord::Migration
  def change
    add_column :signups, :personal_contact_name, :string
    add_column :signups, :personal_contact_email, :string
  end
end
