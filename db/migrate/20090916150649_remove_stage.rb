class RemoveStage < ActiveRecord::Migration
  def self.up
    remove_column :events, :stage
  end

  def self.down
    add_column :events, :stage, :integer
  end
end
