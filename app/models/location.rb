class Location < ActiveRecord::Base
  validates_presence_of :name, :postcode
  validates_length_of [:name, :address_1, "address_2", "address_3", "city", "county", "postcode"], :maximum => 255, :allow_nil => true
  
  belongs_to :possible_duplicate, :class_name => "Location"
  
  before_save :check_duplicate
  
  def check_duplicate
    possible_duplicate?
    true
  end
  
  def possible_duplicate?
    Location.find(:all, :conditions => ["postcode = ?", self.postcode]).each do |location|
      p self.name
      p location.name
      self.possible_duplicate = location if !self.possible_duplicate && Text::Levenshtein.distance(self.name.downcase, location.name.downcase) <= 5
    end
    !! self.possible_duplicate
  end
  
end
