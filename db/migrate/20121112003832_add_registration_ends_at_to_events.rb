class AddRegistrationEndsAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :registration_ends_at, :datetime
  end
end
