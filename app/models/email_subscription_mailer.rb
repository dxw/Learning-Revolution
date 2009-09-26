class EmailSubscriptionMailer < ActionMailer::Base
  def listing(email_subscription)
    subject    'EmailSubscriptionMailer#listing'
    recipients email_subscription.email
    from       ''
    
    body       :greeting => 'Hi,'
  end

  def update(sent_at = Time.now)
    subject    'EmailSubscriptionMailer#update'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
