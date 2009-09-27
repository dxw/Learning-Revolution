class EmailSubscriptionMailer < ActionMailer::Base
  helper ApplicationHelper
  
  def listing(email_subscription, events)
    subject    "Your Learning Revolution events listing"
    recipients email_subscription.email
    from       'Learning Revolution <noreply@learningrevolution.direct.gov.uk>'
    body       :email_subscription => email_subscription, :events => events
  end

  def update(sent_at = Time.now)
    subject    'EmailSubscriptionMailer#update'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
