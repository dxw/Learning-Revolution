class AddMoreInfoUrl < ActiveRecord::Migration
  def self.up
    add_column :events, :more_info, :string
  end

  def self.down
    remove_column :events, :more_info
  end
end
