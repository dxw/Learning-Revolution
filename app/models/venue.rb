class Venue < Location
  def self.find_venues_by_event_conditions(conditions)
    find(:all, :include => :events, :conditions => conditions)
  end

  def self.convert_form_params_into_filter_conditions(filter)
    conditions = {}
    [:theme, :event_type, :venue_id].each do |field|
      conditions["events.#{field}"] = filter[field] unless filter[field].blank?
    end
    conditions["events.start"] = filter[:from]..filter[:to] unless filter[:from].blank? || filter[:to].blank?
    conditions
  end

  def self.find_venues_by_event_params(filter)
    find_venues_by_event_conditions(convert_form_params_into_filter_conditions(filter))
  end

  def find_events_by_event_params(filter)
    events.find(:all, :conditions => Venue.convert_form_params_into_filter_conditions(filter))
  end

  def self.geocode(postcode)
  end

  def has_published_events
    events.select{|e| e.published}.size > 0
  end

  # Upcoming

  def generate_upcoming_venue_id!(force=false)
    return upcoming_venue_id if upcoming_venue_id && !force

    location_string = [address_1, address_2, address_3, city, county, postcode, "UK"].delete_if(&:blank?).join(',')

    upcoming_venue = Upcoming.add_venue!(
      :venuename => name,
      :venueaddress => address_1,
      :venuecity => city,
      :location => location_string,
      :venuezip => postcode
    )

    if upcoming_venue
      self.upcoming_venue_id = upcoming_venue.venue_id
      self.save!
    end

    upcoming_venue_id
  end
end
