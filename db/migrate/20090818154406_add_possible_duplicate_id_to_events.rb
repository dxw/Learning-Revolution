class AddPossibleDuplicateIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :possible_duplicate_id, :integer
  end

  def self.down
    remove_column :events, :possible_duplicate_id
  end
end
