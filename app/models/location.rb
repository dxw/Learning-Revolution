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
    self.class.find(:all, :conditions => ["postcode = ?", self.postcode]).each do |location|
      self.possible_duplicate = location if !self.possible_duplicate && self != location && Text::Levenshtein.distance(self.name.downcase, location.name.downcase) <= 5
    end
    !! self.possible_duplicate
  end
  
  def fix_duplicate(by_removing)
    if by_removing == :original
      possible_duplicate.destroy
      self.possible_duplicate = nil
      self.save
    elsif by_removing == :self
      self.destroy
    end
  end
  
end
