class RemoveMoreInfoFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :further_information
    remove_column :events, :additional_notes
  end

  def self.down
    add_column :events, :further_information, :string
    add_column :events, :additional_notes, :string
  end
end
