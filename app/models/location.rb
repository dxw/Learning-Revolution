class Location < ActiveRecord::Base
  validates_presence_of :name, :postcode, :address_1
  validates_length_of [:name, :address_1, "address_2", "address_3", "city", "county", "postcode"], :maximum => 255, :allow_nil => true
  
  belongs_to :possible_duplicate, :class_name => "Location"
  
  before_save :check_duplicate
  has_many :events, :foreign_key => "location_id"
  
  acts_as_mappable :default_units => :miles, 
                   :default_formula => :sphere, 
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
  
  before_validation :geocode_address
  after_update :update_events_lat_lng_cache
  
  POSTCODE_PATTERN = /[A-Z]{1,2}[0-9R][0-9A-Z]? ?[0-9][A-Z]{2}/i

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
  
  def self.geocode(post_code)
    Geokit::Geocoders::YahooGeocoder.geocode("#{post_code} GB")
  end

  def to_s
    [address_1, address_2, address_3, city, county, postcode].select{|i|i!=nil}.join("\n")
  end
  
  private
  
  def geocode_address
    geo = Location.geocode(postcode)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end
  
  def update_events_lat_lng_cache(lat=self.lat, lng=self.lng)
    events.each { |event| event.cache_lat_lng; event.save }
  end
  
end
