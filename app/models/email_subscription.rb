class EmailSubscription < ActiveRecord::Base
  serialize :filter
  
  validates_presence_of :email
  
  after_create :deliver_listing
  def deliver_listing
    EmailSubscriptionMailer.deliver_listing(self)
    update_attribute(:last_sent_at, Time.now.utc)
  end
end
