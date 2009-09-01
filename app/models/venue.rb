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
  
  
end
