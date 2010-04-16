class EmailSubscriptionMailer < ActionMailer::Base
  helper ApplicationHelper

  def listing(email_subscription, events)
    subject    "Your #{AppConfig.site_name} events listing"
    recipients email_subscription.email
    from       "#{AppConfig.site_name} <#{AppConfig.contact_email}>"
    body       :email_subscription => email_subscription, :events => events
  end

  def update(email_subscription, events)
    subject    "Your #{AppConfig.site_name} events update"
    recipients email_subscription.email
    from       "#{AppConfig.site_name} <#{AppConfig.contact_email}>"
    body       :email_subscription => email_subscription, :events => events
  end

end
