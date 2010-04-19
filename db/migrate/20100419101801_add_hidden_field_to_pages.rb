class AddHiddenFieldToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :hidden, :bool
  end

  def self.down
    remove_column :pages, :hidden
  end
end
