class AddRejectReasonAndRevokeReasonToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reject_reason, :text
    add_column :events, :revoke_reason, :text
  end
end
