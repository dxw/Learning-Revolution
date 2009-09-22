class EventsController < ApplicationController
  before_filter :ensure_filters
  before_filter :new_event, :except => [:create, :find_venue]
  before_filter :add_events_to_page_title
  
  def index
    # params[:in_the_queue] = 'true' # switch this on to see the post event view
    # params[:first_visit] = true # uncomment this to see the example view
    
    if(params[:filter][:location] == 'Enter your postcode here')
      params[:filter][:location] = ''
    end
    @first_day_of_month = Time.parse("#{params[:month]} #{params[:year]}")
    if params[:view] == "map"
      add_page_title "Map view"
      set_map_bounds
      set_from_and_to_to_dates
      @venues = Venue.find_venues_by_event_params(params[:filter])
    else
      add_page_title "Calendar view"
      @events = Event.find_by_month_with_filter_from_params(@first_day_of_month, params[:filter])
      respond_to do |format|
        format.html
        format.atom { render :template => 'events/index.atom.rxml' }
        format.ics { render :text => events_to_ical(@events) }
        format.xml { render :text => @events.to_xml }
        format.json { render :text => @events.to_json }
      end
    end
  end

  def show
    if params[:id].nil?
      puts params.inspect
      @event = Event.first_for_day("2009-10-#{params[:day]}")
    else
      @event = Event.find_by_slug(params[:id])
    end
    
    add_page_title @event.title
    redirect_to path_for_event(@event) and return if request.format == 'html' && request.path != path_for_event(@event)
    respond_to do |format|
      format.html
      format.ics { render :text => @event.to_ical }
      format.xml { render :text => @event.to_xml }
      format.json { render :text => @event.to_json }
    end
  end
  
  def find_venue
    process_dates
    @new_event = Event.new(params[:event])
    if valid_cyber_event? and valid_datetimes? and tandc_checked?
      render :action => :preview and return
    elsif event_valid_with_postcode? and valid_datetimes? and tandc_checked?
      @venues = Venue.find_all_by_postcode(params[:venue][:postcode])
    else
      handle_postcode_errors
      handle_datetime_errors
      handle_tandc
      render :action => :create
    end
  end
  
  def create
    @new_event = Event.new(params[:event])
    if params[:cyberevent]
      succesful_save_redirect if @new_event.save
    else
      find_or_create_venue
      succesful_save_redirect if @new_event.valid? && @venue.valid? && @new_event.save!
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
  
  def events_to_ical(events)
    calendar = Icalendar::Calendar.new
    events.each do |event|
      calendar.add_event event.to_ical_event
    end
    calendar.to_ical
  end
  
  def new_event
    @new_event = Event.new(params[:event])
    if params[:venue]
      @new_event.venue = Venue.new(params[:venue])
    elsif params[:event].andand[:location_id]
      @new_event.venue = Venue.find(params[:event][:location_id])
    end
  end
  
  def handle_postcode_errors
    unless params[:cyberevent]
      if params[:venue][:postcode].blank?
        @new_event.errors.add_to_base "Postcode can't be blank"
      elsif !postcode_valid?
        @new_event.errors.add_to_base "The postcode you entered seems to be invalid"
      elsif !postcode_exists?
        @new_event.errors.add_to_base "We couldn't find anywhere with this postcode"
      end
    end
  end
  
  def event_valid_with_postcode?
    @new_event.valid? && !params[:venue][:postcode].blank? && postcode_valid? && postcode_exists?
  end
  
  def postcode_valid?
    params[:venue][:postcode] =~ Location::POSTCODE_PATTERN
  end
  
  def postcode_exists?
    @postcode_exists ||= Location.geocode(params[:venue][:postcode]).accuracy
  end
  
  def valid_cyber_event?
    params[:cyberevent] && @new_event.valid?
  end
  
  def succesful_save_redirect
    flash[:notice] = "Event created successfully"
    redirect_to current_events_path
  end
  
  def find_or_create_venue
    if params[:event][:location_id].blank?
      @venue = @new_event.venue = Venue.new(params[:venue])
    else
      @venue = @new_event.venue = Venue.find(params[:event][:location_id])
    end
  end
  
  def process_dates
    if params[:startday] and params[:starthour] and params[:startminute]
      d = params[:startday].to_i
      h = params[:starthour].to_i
      m = params[:startminute].to_i
      params[:event][:start] = Time.zone.local(2009, 10, d, h, m).to_s
    end
    if params[:endday] and params[:endhour] and params[:endminute]
      d = params[:endday].to_i
      h = params[:endhour].to_i
      m = params[:endminute].to_i
      begin
        params[:event][:end] = Time.zone.local(2009, 10, d, h, m).to_s
      rescue ArgumentError
      end
    end
  end

  def add_events_to_page_title
    add_page_title "Events"
  end
  def valid_datetimes?
    if @new_event.end and @new_event.end < @new_event.start
      false
    else
      true
    end
  end
  def handle_datetime_errors
    unless valid_datetimes?
      @new_event.errors.add_to_base "The event can't finish before it's begun"
    end
  end
  def tandc_checked?
    params[:accept_tnc] == 'true'
  end
  def handle_tandc
    unless tandc_checked?
      @new_event.errors.add_to_base "You must accept the terms and conditions"
    end
  end
end
