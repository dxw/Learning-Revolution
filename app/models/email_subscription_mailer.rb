class EmailSubscriptionMailer < ActionMailer::Base
  helper ApplicationHelper

  def listing(email_subscription, events)
    subject    "Your Event Thing events listing"
    recipients email_subscription.email
    from       'Event Thing <noreply@example.uk>'
    body       :email_subscription => email_subscription, :events => events
  end

  def update(email_subscription, events)
    subject    "Your Event Thing events update"
    recipients email_subscription.email
    from       'Event Thing <noreply@example.uk>'
    body       :email_subscription => email_subscription, :events => events
  end

end
