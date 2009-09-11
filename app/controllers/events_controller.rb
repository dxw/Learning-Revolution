class EventsController < ApplicationController
  before_filter :ensure_filters
  before_filter :new_event, :except => [:create]
  
  def index
    @first_day_of_month = Time.parse("#{params[:month]} #{params[:year]}")
    if params[:view] == "map"
      set_map_bounds
      set_from_and_to_to_dates
      @venues = Venue.find_venues_by_event_params(params[:filter])
    else
      @events = Event.find_by_month_with_filter_from_params(@first_day_of_month, params[:filter])
      respond_to do |format|
        format.html
        format.ics { render :text => events_to_ical(@events) }
        format.xml { render :text => @events.to_xml }
        format.json { render :text => @events.to_json }
      end
    end
  end

  def show
    params[:view] = "list"
    @event = Event.find_by_slug(params[:id])
    redirect_to path_for_event(@event) and return if request.format == 'html' && request.path != path_for_event(@event)
    respond_to do |format|
      format.html
      format.ics { render :text => @event.to_ical }
      format.xml { render :text => @event.to_xml }
      format.json { render :text => @event.to_json }
    end
    
    params[:view] = 'list'
  end
  
  def find_venue
    @new_event = Event.new(params[:event])
    if params[:cyberevent]
      if @new_event.valid?
        render :action => :preview and return
      else
        render :action => :create and return
      end
    end
    postcode_matches = params[:venue][:postcode] =~ Location::POSTCODE_PATTERN
    geo = Location.geocode(params[:venue][:postcode])
    if @new_event.valid? && !params[:venue][:postcode].blank? && postcode_matches && geo.accuracy
      @venues = Venue.find_all_by_postcode(params[:venue][:postcode])
    else
      params[:postcode] = "We couldn't find anywhere with this postcode" unless geo.accuracy
      params[:postcode] = "The post code you entered seems to be invalid" unless postcode_matches
      params[:postcode] = "Post Code can't be blank" if params[:venue][:postcode].blank?
      render :action => :create
    end
  end
  
  def create
    @new_event = Event.new(params[:event])
    if params[:cyberevent]
      if @new_event.save
        flash[:notice] = "Event created successfully"
        redirect_to current_events_path
      end
    else
      if params[:event][:location_id].blank?
        @venue = @new_event.venue = Venue.new(params[:venue])
      else
        @venue = @new_event.venue = Venue.find(params[:event][:location_id])
      end
      @new_event.valid?
      @venue.valid?
      if @new_event.valid? && @venue.valid? && @new_event.save!
        flash[:notice] = "Event created successfully"
        redirect_to current_events_path
      end
    end
  end
  
  private
  
  def ensure_filters
    params[:filter] ||= {}
    params[:view] ||= 'calendar'
  end
  
  include Geokit::Geocoders
  def set_map_bounds
    if params[:filter][:location].blank?
      @start_lat = 54
      @start_lng = -4.064941
      @start_zoom = 6
    else
      location = MultiGeocoder.geocode(params[:filter][:location] + " GB")
      @start_lat = location.lat
      @start_lng = location.lng
      @start_zoom = 12
    end
  end
  
  def set_from_and_to_to_dates
    params[:filter][:from_day] ||= 1
    params[:filter][:to_day] ||= @first_day_of_month.end_of_month.day
    
    params[:filter][:from] = Time.parse("#{params[:filter][:from_day]} #{params[:month]} #{params[:year]}") if params[:filter][:from_day]
    params[:filter][:to] = Time.parse("#{params[:filter][:to_day]} #{params[:month]} #{params[:year]}") if params[:filter][:to_day]
  end
  
  def new_event
    @new_event = Event.new(params[:event])
    @new_event.venue = Venue.new(params[:event].andand[:venue])
  end

  def events_to_ical(events)
    calendar = Icalendar::Calendar.new
    events.each do |event|
      calendar.add_event event.to_ical_event
    end
    calendar.to_ical
  end

end
