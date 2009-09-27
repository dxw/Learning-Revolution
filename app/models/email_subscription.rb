class EmailSubscription < ActiveRecord::Base
  serialize :filter
  
  validates_presence_of :email
  
  after_create :deliver_listing
  def deliver_listing
    EmailSubscriptionMailer.deliver_listing(self, all_events)
    update_attribute(:last_sent_at, Time.now.utc)
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
end
