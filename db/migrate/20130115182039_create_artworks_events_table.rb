class CreateArtworksEventsTable < ActiveRecord::Migration
  def self.up
    create_table :artworks_events, :id => false do |t|
        t.references :artwork
        t.references :event
    end
    add_index :artworks_events, [:artwork_id, :event_id]
    add_index :artworks_events, [:event_id, :artwork_id]
  end

  def self.down
    drop_table :artworks_events
  end
end
