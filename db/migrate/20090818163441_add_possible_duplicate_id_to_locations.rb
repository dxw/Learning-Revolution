class AddPossibleDuplicateIdToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :possible_duplicate_id, :integer
  end

  def self.down
    remove_column :locations, :possible_duplicate_id
  end
end
