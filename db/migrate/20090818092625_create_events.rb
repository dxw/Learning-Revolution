class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :theme
      t.string :type
      t.integer :stage
      t.datetime :start
      t.datetime :end
      t.string :cost
      t.integer :min_age
      t.references :location
      t.string :organisation
      t.string :contact_name
      t.string :contact_phone_number
      t.string :contact_email_address
      t.string :further_information
      t.text :additional_notes
      t.boolean :published
      t.string :picture
      t.boolean :featured

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
