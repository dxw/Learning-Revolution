require 'bitly'

class Event < ActiveRecord::Base
  validates_presence_of :title, :start, :venue
  
  belongs_to :possible_duplicate, :class_name => "Event"
  
  before_save :check_duplicate
  
  before_create :make_bitly_url
  
  before_validation :cache_lat_lng
  
  belongs_to :venue, :foreign_key => "location_id"
  
  
  named_scope :published, :conditions => { :published => true }
  named_scope :featured, :conditions => { :featured => true, :published => true }, :limit => 13
  
  acts_as_mappable :default_units => :miles, 
                   :default_formula => :sphere, 
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
  
  Themes = ["Food and Cookery", "Languages and Travel", "Heritage and History", "Culture, Arts & Crafts", "Music and Performing Arts", "Sport and Physical Activity", "Health and Wellbeing", "Nature & the Environment", "Technology & Broadcasting", "Other"]
  Types = ["Class"]
  
  def self.find_by_month_with_filter_from_params(date, params={})
    self.find_by_month_with_filter(date, turn_filter_params_into_find_options(params))
  end
  def self.turn_filter_params_into_find_options(params)
    find_options = {}
    if !params[:theme].blank? && params[:event_type].blank?
      find_options[:conditions] = ["(theme LIKE ?)", "%#{params[:theme]}%"]
    end
    if params[:theme].blank? && !params[:event_type].blank?
      find_options[:conditions] = ["(event_type LIKE ?)", "%#{params[:event_type]}%"]
    end
    if !params[:theme].blank? && !params[:event_type].blank?
      find_options[:conditions] = ["(theme LIKE ? AND event_type LIKE ?)", "%#{params[:theme]}%", "%#{params[:event_type]}%"]
    end
    
    unless params[:location].blank?
      find_options[:origin] = params[:location] + " GB"
      find_options[:within] = 5
    end

    find_options[:limit] = 3
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
  
  
  def self.counts_for_month(date)
    count(
      :group => "date(start)",
      :conditions => ["start >= ? AND start < ?", date.beginning_of_month.to_time.utc, date.end_of_month.to_time.end_of_day.utc]
    )
  end
  
  def same_day_events
    Event.find(:all, :conditions => ["DATE(start) = ? AND id != ?", self.start.utc.to_date, self.id])
  end
  
  def self.first_for_today
     Event.find(:first, :conditions => ["DATE(start) >= ?", Date.today], :order => "start ASC") || Event.find(:first, :conditions => ["DATE(start) <= ?", Date.today], :order => "start DESC")
  end
  
  def check_duplicate
    possible_duplicate?
    true
  end
  
  def make_bitly_url
    
    event_uri =  AppConfig.event_uri_template
    event_uri.gsub!(/:year/, start.year.to_s)
    event_uri.gsub!(/:month/, start.month.to_s)
    event_uri.gsub!(/:day/, start.day.to_s)
    event_uri.gsub!(/:slug/, slug)
    
    event_uri = AppConfig.bitly_target_host + event_uri
    
    bitly = Bitly.new(AppConfig.bitly_account, AppConfig.bitly_api_key)
    
    self.bitly_url = bitly.shorten(event_uri)
  end
  
  def possible_duplicate?
    Event.find(:all, :conditions => ["DATE(start) = ?", self.start.utc.to_date]).each do |event|
      self.possible_duplicate = event if !self.possible_duplicate && self != event && Text::Levenshtein.distance(self.title.downcase, event.title.downcase) <= 5
    end
    !! self.possible_duplicate
  end
  
  def fix_duplicate(by_removing)
    if by_removing == :original
      possible_duplicate.destroy
      self.possible_duplicate = nil
      self.save
    elsif by_removing == :self
      self.destroy
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
end
