class Notifier < ActionMailer::Base

  def error_notification(error_msg,exception=nil)
    recipients ['alerts@thedextrousweb.com']
    from       "the-server@learning.dev.thedextrousweb.com"
    subject    "Learning Rev: #{error_msg} #{exception.andand.class}"
    body       :message => error_msg, :exception => exception
  end

end
