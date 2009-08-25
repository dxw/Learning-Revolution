class Event < ActiveRecord::Base
  validates_presence_of :title, :start
  
  belongs_to :possible_duplicate, :class_name => "Event"
  
  before_save :check_duplicate
  
  belongs_to :venue, :foreign_key => "location_id"
  
  
  named_scope :published, :conditions => { :published => true }
  named_scope :featured, :conditions => { :featured => true, :published => true }, :limit => 13
  
  def self.find_for_month_with_filter(date, options={})
    sql_query = []
    conditions = []
    options.each_pair do |type, value|
      sql_query << "#{type} LIKE ?"
      conditions << "%#{value}%"
    end
    conditions.unshift(sql_query.join(" AND "))
    self.find_for_month(date, conditions)
  end
  def self.find_for_month(date, conditions={})
    queries = []
    31.times do |day|
      day = Time.parse("#{date.month}/#{day+1} #{date.year}")
      start_time = day.beginning_of_day.utc
      end_time = day.end_of_day.utc
      queries << "(SELECT * FROM `events` WHERE #{sanitize_sql_array(conditions) + " AND " unless conditions.empty?}(start >= '#{start_time.to_s(:sql)}' AND start < '#{end_time.to_s(:sql)}') LIMIT 3)"
    end
    self.find_by_sql(queries.join(" UNION "))
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
end
