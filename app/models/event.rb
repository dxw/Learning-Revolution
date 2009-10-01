class Event < ActiveRecord::Base
  validates_presence_of :title, :start, :contact_name, :theme, :event_type, :contact_email_address
  validates_format_of :contact_email_address, :with => /^$|\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  
  belongs_to :possible_duplicate, :class_name => "Event"
  
  before_save :check_duplicate
  before_validation_on_create :cache_lat_lng
  before_validation :check_more_info, :strip_html

  after_create :make_bitly_url
  
  belongs_to :venue, :foreign_key => "location_id"  
  
  named_scope :published, :conditions => { :published => true }
  named_scope :featured, :conditions => { :featured => true, :published => true }, :limit => 13
  
  acts_as_mappable :default_units => :miles, 
                   :default_formula => :sphere, 
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng,
                   :include_results_with_no_location => true
  
  Themes = ["Community Action", "Food and Cookery", "Languages and Travel", "Heritage and History", "Culture, Arts & Crafts", "Music and Performing Arts", "Sport and Physical Activity", "Health and Wellbeing", "Nature & the Environment", "Technology & Broadcasting", "Other"]
  Themes.sort!
  
  Types = ["Workshop", "Taster Session", "Exhibition", "Mini-project", "Competition", "Performance", "Demonstration", "Display", "Class", "Other"]
  Types.sort!
  
  Days = (1..Date.civil(2009, 10, -1).day).to_a
  Hours = (0..23).map{|h|'%02d'%h}
  Minutes = (0...60).step(5).map{|m|'%02d'%m}
  
  HUMANIZED_ATTRIBUTES = {
    :title => "Event name"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
    
  def self.find_by_month_with_filter_from_params(date, params={})
    # Have this check in here as the caching doesn't work in dev mode. Better solution desired.
    if RAILS_ENV == "development"
      self.find_by_month_with_filter(date, turn_filter_params_into_find_options(params))
    else
      Rails.cache.fetch("#{date}#{params}") do
        self.find_by_month_with_filter(date, turn_filter_params_into_find_options(params))
      end
    end
  end
  def self.turn_filter_params_into_find_options(params)
    find_options = {}
    find_options[:conditions] ||= []
    if !params[:theme].blank? && params[:event_type].blank?
      find_options[:conditions] = ["(theme LIKE ?)", "%#{params[:theme]}%"]
    end
    if params[:theme].blank? && !params[:event_type].blank?
      find_options[:conditions] = ["(event_type LIKE ?)", "%#{params[:event_type]}%"]
    end
    if !params[:theme].blank? && !params[:event_type].blank?
      find_options[:conditions] = ["(theme LIKE ? AND event_type LIKE ?)", "%#{params[:theme]}%", "%#{params[:event_type]}%"]
    end

    if find_options[:conditions][0]
      find_options[:conditions][0] += " AND (published = 1)"
    else
      find_options[:conditions][0] = "(published = 1)"
    end
    
    unless params[:location].blank?
      find_options[:origin] = params[:location] + " GB"
      find_options[:within] = 5
    end

    find_options[:limit] = 4
    find_options
  end
  def self.find_by_month_with_filter(date, find_options={})
    self.find_by_sql(sql_for_events_in_month_with_filter(date, find_options))
  end
  def self.sql_for_events_in_month_with_filter(date, find_options={})
    queries = []
    first_day = date.beginning_of_month
    query_for_first_day = sql_for_events_on_day_with_filter(date, find_options)
    
    # Uses gsub on a pre calculated sql statement for speed
    first_day.end_of_month.day.times do |day_offset|
      day = first_day + day_offset.days
      query_for_first_day.gsub!(/\d+-\d+-\d+ \d\d:00:00/, day.beginning_of_day.utc.to_s(:sql))
      query_for_first_day.gsub!(/\d+-\d+-\d+ \d\d:59:59/, day.end_of_day.utc.to_s(:sql))
      queries << query_for_first_day.dup
    end
    "("+queries.join(") UNION (")+")"
  end
  def self.sql_for_events_on_day_with_filter(date, args={}, location_sql=nil)
    args = add_date_scope_for_day(args, date)
    # This method is from geokit to patch in the location sql
    prepare_for_find_or_count(:find, [args])
    # This method is what ActiveRecord.find uses to generate the SQL
    construct_finder_sql(args)
  end
  def self.add_date_scope_for_day(args, date)
    start_time = date.beginning_of_day.utc
    end_time = date.end_of_day.utc
    args[:conditions] ||= []
    if args[:conditions][0]
      args[:conditions][0] += " AND (start >= '#{start_time.to_s(:sql)}' AND start < '#{end_time.to_s(:sql)}')"
    else
      args[:conditions][0] = "(start >= '#{start_time.to_s(:sql)}' AND start < '#{end_time.to_s(:sql)}')"
    end
    args
  end
    
  def same_day_events
    zone_beginning_of_day = Time.local(self.start.year, self.start.month, self.start.day)
    utc_beginning_of_day = zone_beginning_of_day.utc
    utc_end_of_day = (utc_beginning_of_day+1.day)
    Event.find(:all, :conditions => ["start >= ? AND start < ? AND published = 1", utc_beginning_of_day.strftime('%Y-%m-%d %H:%M'), utc_end_of_day.strftime('%Y-%m-%d %H:%M')])
  end  
  
  def self.first_for_day(day)
    zone_beginning_of_day = Time.local(day.year, day.month, day.day)
    utc_beginning_of_day = zone_beginning_of_day.utc
    utc_end_of_day = (utc_beginning_of_day+1.day)
    Event.find(:first, :conditions => ["start >= ? AND start < ? AND published = 1", utc_beginning_of_day.strftime('%Y-%m-%d %H:%M'), utc_end_of_day.strftime('%Y-%m-%d %H:%M')], :order => "start ASC")
  end
  
  def self.step_backwards_from(event)
    Event.find(:first, :conditions => ["DATE(start) < DATE(?) AND published = 1", event.start], :order => "start DESC", :limit => 1)
  end
  
  def self.step_forwards_from(event)
    Event.find(:first, :conditions => ["DATE(start) > DATE(?) AND published = 1", event.start], :order => "start ASC", :limit => 1)
  end
  
  def check_duplicate
    possible_duplicate?
    true
  end
  
  def make_bitly_url
    event_uri =  AppConfig.event_uri_template.dup
    event_uri.gsub!(/:year/, self.start.year.to_s)
    event_uri.gsub!(/:month/, self.start.month.to_s)
    event_uri.gsub!(/:day/, self.start.day.to_s)
    event_uri.gsub!(/:stub/, self.slug)
    
    event_uri = AppConfig.bitly_target_host + event_uri
    
    bitly = Bitly.new(AppConfig.bitly_account, AppConfig.bitly_api_key)
    
    self.update_attribute(:bitly_url, bitly.shorten(event_uri).short_url)
  rescue BitlyError
    self.update_attribute(:bitly_url, event_uri)
  end
  
  def possible_duplicate?
    self.possible_duplicate = nil
    
    Event.find(:all, :conditions => ["start = ?", start]).each do |event|
      self.possible_duplicate = event if !self.possible_duplicate && self != event && Text::Levenshtein.distance(self.title.downcase, event.title.downcase) <= 5
    end
    
    !! self.possible_duplicate
  end
  
  def fix_duplicate(by_removing)
    if by_removing == :original
      possible_duplicate.destroy
      
      self.possible_duplicate?
      
      self.save
    elsif by_removing == :self
      
      other_event = possible_duplicate
     
      self.destroy
      
      other_event.possible_duplicate?
    end
  end
  
  def approve!
    self.published = true
    self.save
  end
  
  def slug
    "#{title.gsub(/[^a-zA-Z0-9 ]/, '').parameterize.downcase}-#{id}"
  end
  
  def self.find_by_slug(slug)
    find_by_id(slug.match(/-(\d+)$/).andand[1])
  end
    
  def cache_lat_lng
    self.lat, self.lng = venue.lat, venue.lng if venue
  end
  def to_ical_event
    event = Icalendar::Event.new
    event.dtstart = start.to_datetime if start
    event.dtend = self.end.to_datetime if self.end
    event.summary = title
    event.description = description ? description : ""
    event.description << "\n\nMore info: #{bitly_url}"
    event.created = created_at.to_datetime if created_at
    event.last_modified = updated_at.to_datetime if updated_at
    event.location = self.venue.to_s
    event.geo = Icalendar::Geo.new(lat,lng) if lat and lng
    event.organizer = organisation
    event.url = bitly_url
    event.duration = start - self.end if self.end

    event
  end
  def to_ical
    cal = Icalendar::Calendar.new
    cal.add_event to_ical_event
    cal.to_ical
  end
 
  
  def check_more_info
    self.more_info = "http://#{more_info}" if !more_info.nil? && more_info != '' && more_info.match(/^http:\/\//) == nil 
    
    true
  end

  def strip_html
    self.description.andand.gsub!(%r[</?.*?>],'')
  end
  
  def provider_name
    if provider.blank?
      nil
    else
      provider.split('/')[-1].split('.')[0..-2].join('.')
    end
  end
  def provider_badge
    '/' + AppConfig.badge + '/' + CGI::escape(provider)
  end
  def self.list_providers
    Dir.glob(RAILS_ROOT + '/public/' + AppConfig.badge + '/*').map do
      |pr|
      e = Event.new(:provider=>pr.split('/')[-1])
      [e.provider_name, e.provider]
    end
  end
  
  # Upcoming
  
  def posted_to_upcoming?
    if posted_to_upcoming_at
      true
    else
      false
    end
  end
  
  def post_to_upcoming!(force=false)
    return if posted_to_upcoming? && !force
    
    # Upcoming can't handle events without a physical venue
    return unless venue
    
    upcoming_venue_id = venue.upcoming_venue_id || venue.generate_upcoming_venue_id!
    
    upcoming_event = Upcoming.add_event!(
      :name => title,
      :venue_id => upcoming_venue_id,
      :category_id => 5, # 'Education - Lectures, workshops'
      :start => start,
      :end => self.end,
      :description => description,
      :url => "http://learningrevolution.direct.gov.uk/events/#{start.year}/#{Date::MONTHNAMES[start.month]}/#{start.day}/#{slug}"
    )
    
    self.upcoming_event_id = upcoming_event.event_id
    self.posted_to_upcoming_at = Time.now.utc
    self.save!
  end
  
  def self.post_pending_to_upcoming!
    published.all(:conditions => "posted_to_upcoming_at IS NULL").each do |event|
      begin
        event.post_to_upcoming!
      rescue => exception
        Rails.logger.error("Error posting event #{id} to Upcoming:\n#{exception.message}")
      end
    end
  end
end
