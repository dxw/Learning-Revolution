class EmailSubscriptionMailer < ActionMailer::Base
  helper ApplicationHelper
  
  def listing(email_subscription, events)
    subject    "Your Learning Revolution events listing"
    recipients email_subscription.email
    from       'Learning Revolution <noreply@learningrevolution.direct.gov.uk>'
    body       :email_subscription => email_subscription, :events => events
  end

  def update(email_subscription, events)
    subject    "Your Learning Revolution events update"
    recipients email_subscription.email
    from       'Learning Revolution <noreply@learningrevolution.direct.gov.uk>'
    body       :email_subscription => email_subscription, :events => events
  end

end
