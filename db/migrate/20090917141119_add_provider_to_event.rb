
class AddProviderToEvent < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :providers do |t|
      t.string :name
      t.string :badge
    end
    add_column :events, :provider_id, :int
  end

  def self.down
    drop_table :providers
    drop_column :events, :provider_id
  end
end
