class Location < ActiveRecord::Base
  validates_presence_of :name, :postcode
  validates_length_of [:name, :address_1, "address_2", "address_3", "city", "county", "postcode"], :maximum => 255, :allow_nil => true
end
