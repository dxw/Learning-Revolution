class AddUpcomingIds < ActiveRecord::Migration
  def self.up
    add_column :locations, :upcoming_venue_id, :integer
    add_column :events, :upcoming_event_id, :integer
    add_column :events, :posted_to_upcoming_at, :timestamp
  end

  def self.down
    remove_column :events, :posted_to_upcoming_at
    remove_column :events, :upcoming_event_id
    remove_column :locations, :upcoming_venue_id
  end
end
