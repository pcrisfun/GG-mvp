class AddHelpPostingSentToEvents < ActiveRecord::Migration
  def change
    add_column :events, :help_posting_sent, :boolean, :null => false, :default => false
  end
end
