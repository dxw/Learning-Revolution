class EventMailer < ActionMailer::Base
  def succesfully_added(event)
    subject    "Your Learning Revolution event has been saved"
    recipients event.contact_email_address
    from       'Learning Revolution <noreply@example.uk>'
    body       :event => event
  end

  def succesfully_published(event)
    subject    "Your Learning Revolution event has been approved and published"
    recipients event.contact_email_address
    from       'Learning Revolution <noreply@example.uk>'
    body       :event => event
  end

end
