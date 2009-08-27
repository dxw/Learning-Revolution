class AddIndexesToEvents < ActiveRecord::Migration
  def self.up
    add_index :events, :lat
    add_index :events, :lng
    add_index :events, :start
  end

  def self.down
    remove_index :events, :lat
    remove_index :events, :lng
    remove_index :events, :start
  end
end
