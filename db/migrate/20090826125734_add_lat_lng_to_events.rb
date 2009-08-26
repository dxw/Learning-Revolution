class AddLatLngToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :lat, :float
    add_column :events, :lng, :float
  end

  def self.down
    remove_column :events, :lat
    remove_column :events, :lng
  end
end
