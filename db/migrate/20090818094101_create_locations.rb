class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :city
      t.string :county
      t.string :postcode
      
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
