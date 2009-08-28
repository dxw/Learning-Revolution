class Venue < Location
  def self.find_venues_by_event_filter(filter)
    find(:all)
  end
  
end
