class AddBitlyUrlToEvent < ActiveRecord::Migration
  def self.up
    add_column(:events, :bitly_url, :string) 
  end

  def self.down
    add_column(:events, :bitly_url)
  end
end
