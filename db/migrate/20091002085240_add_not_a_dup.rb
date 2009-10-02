class AddNotADup < ActiveRecord::Migration
  def self.up
    add_column(:events, :not_a_dup, :boolean) 
    add_column(:locations, :not_a_dup, :boolean) 
  end

  def self.down
    remove_column(:events, :not_a_dup, :boolean) 
    remove_column(:locations, :not_a_dup, :boolean) 
  end
end
