require 'digest/sha1'

class EmailSubscription < ActiveRecord::Base
  serialize :filter
  
  validates_presence_of :email
  validates_presence_of :secret
  
  after_create :deliver_listing
  def deliver_listing
    EmailSubscriptionMailer.deliver_listing(self, all_events)
    update_attribute(:last_sent_at, Time.now.utc)
  end
  
  def deliver_update
    events = updated_events
    if events.present?
      EmailSubscriptionMailer.deliver_update(self, events)
      update_attribute(:last_sent_at, Time.now.utc)
    end
  end
  
  def all_events
    Event.find_all_with_filter_from_params(filter)
  end
  
  def updated_events
    if last_sent_at
      Event.find_all_with_filter_from_params_added_since(last_sent_at, filter)
    else
      all_events
    end
  end
  
  before_validation_on_create :generate_new_secret!
  def generate_new_secret!
    self.secret = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)[0..7]
  end
  
  named_scope :confirmed, :conditions => "confirmed_at IS NOT NULL"
  
  def confirm!
    update_attribute(:confirmed_at, Time.now.utc)
  end
  
  def self.deliver_all_updates!
    confirmed.each do |es|
      begin
        es.deliver_update
        
      # Don't give up on the whole batch if one email fails for some reason
      rescue => exception
        Rails.logger.error("Email subscription sending error:\n#{exception.message}")
      end
    end
  end
end
