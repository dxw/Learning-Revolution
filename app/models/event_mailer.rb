class EventMailer < ActionMailer::Base
  def succesfully_added(event)
    subject    "Your #{AppConfig.site_name} events listing"
    recipients event.contact_email_address
    from       "#{AppConfig.site_name} <#{AppConfig.contact_email}>"
    body       :event => event
  end

  def succesfully_published(event)
    subject    "Your #{AppConfig.site_name} events listing"
    recipients event.contact_email_address
    from       "#{AppConfig.site_name} <#{AppConfig.contact_email}>"
    body       :event => event
  end

end
