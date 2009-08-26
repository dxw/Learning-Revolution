class Event < ActiveRecord::Base
  validates_presence_of :title, :start, :venue
  
  belongs_to :possible_duplicate, :class_name => "Event"
  
  before_save :check_duplicate
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
  
  def self.sql_for_events_in_month_with_filter(date, conditions={})
    queries = []
    31.times do |day|
      queries << Event.sql_for_events_on_day_with_filter(Time.parse("#{date.month}/#{day+1} #{date.year}"), conditions.dup)
    end
    queries.join(" UNION ")
  end
    
  def self.sql_for_events_on_day_with_filter(date, args={})
    start_time = date.beginning_of_day.utc
    end_time = date.end_of_day.utc

    args = [args]
    args[0] ||= {}
    args[0][:conditions] ||= []
    if args[0][:conditions][0]
      args[0][:conditions][0] += " AND (start >= '#{start_time.to_s(:sql)}' AND start < '#{end_time.to_s(:sql)}')"
    else
      args[0][:conditions][0] = "(start >= '#{start_time.to_s(:sql)}' AND start < '#{end_time.to_s(:sql)}')"
    end

    prepare_for_find_or_count(:find, args)
    
    construct_finder_sql(args[0])
  end
  
  def self.find_by_month_with_filter(date, input_conditions={})
    self.find_by_sql(sql_for_events_in_month_with_filter(date, input_conditions))
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
  
  def check_duplicate
    possible_duplicate?
    true
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
