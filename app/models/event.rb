class Event < ActiveRecord::Base
  validates_presence_of :title, :start
  
  belongs_to :possible_duplicate, :class_name => "Event"
  
  before_save :check_duplicate
  
  def check_duplicate
    possible_duplicate?
    true
  end
  
  def possible_duplicate?
    Event.find(:all, :conditions => ["DATE(start) = ?", self.start.to_date]).each do |event|
      self.possible_duplicate = event if !self.possible_duplicate && Text::Levenshtein.distance(self.title, event.title) <= 5
    end
    !! self.possible_duplicate
  end
end
