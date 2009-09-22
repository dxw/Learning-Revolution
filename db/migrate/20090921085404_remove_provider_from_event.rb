class RemoveProviderFromEvent < ActiveRecord::Migration
  def self.up
    drop_table :providers
    remove_column :events, :provider_id
    add_column :events, :provider, :string
  end

  def self.down
    create_table :providers do |t|
      t.string :name
      t.string :badge
    end
    add_column :events, :provider_id, :int
    remove_column :events, :provider, :string
  end
end
