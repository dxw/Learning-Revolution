# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090818094101) do

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "theme"
    t.string   "type"
    t.integer  "stage"
    t.datetime "start"
    t.datetime "end"
    t.string   "cost"
    t.integer  "min_age"
    t.integer  "location_id"
    t.string   "organisation"
    t.string   "contact_name"
    t.string   "contact_phone_number"
    t.string   "contact_email_address"
    t.string   "further_information"
    t.text     "additional_notes"
    t.boolean  "published"
    t.string   "picture"
    t.boolean  "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_3"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
