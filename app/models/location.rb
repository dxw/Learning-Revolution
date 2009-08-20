class Location < ActiveRecord::Base
  validates_presence_of :name, :postcode
  validates_length_of [:name, :address_1, "address_2", "address_3", "city", "county", "postcode"], :maximum => 255, :allow_nil => true
  
  belongs_to :possible_duplicate, :class_name => "Location"
  
  before_save :check_duplicate
  has_many :events, :foreign_key => "location_id"
  
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
      move_events_from(possible_duplicate)
      possible_duplicate.destroy
      self.possible_duplicate = nil
      self.save
    elsif by_removing == :self
      possible_duplicate.move_events_from(self)
      self.destroy
    end
  end
  
  def move_events_from(new_event)
    new_event.events.each do |event|
      event.venue = self
      event.save
    end
  end
  
end
