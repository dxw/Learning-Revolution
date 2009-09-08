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
      @event_counts = Event.counts_for_month(@first_day_of_month)
    end
  end

  def show
    @event = Event.find_by_slug(params[:id])
    fix_path
    
    params[:view] = 'list'
  end
  
  def find_venue
    @new_event = Event.new(params[:event])
    if params[:cyberevent]
      if @new_event.save
        flash[:notice] = "Event created successfully"
        redirect_to current_events_path and return
      else
        render :action => :create and return
      end
    end
    postcode_matches = params[:venue][:postcode] =~ Location::POSTCODE_PATTERN
    geo = Location.geocode(params[:venue][:postcode])
    if @new_event.valid? && !params[:venue][:postcode].blank? && postcode_matches && geo.accuracy
      @venue = Venue.find_by_postcode(params[:venue][:postcode])
    else
      params[:postcode] = "We couldn't find anywhere with this postcode" unless geo.accuracy
      params[:postcode] = "The post code you entered seems to be invalid" unless postcode_matches
      params[:postcode] = "Post Code can't be blank" if params[:venue][:postcode].blank?
      render :action => :create
    end
  end
  
  def create
    @new_event = Event.new(params[:event])
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
    else
    end
  end
  
  private
  
  def fix_path
    redirect_to path_for_event(@event) unless request.path == path_for_event(@event)
  end
  
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

end
