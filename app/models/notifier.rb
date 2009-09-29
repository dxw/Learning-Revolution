class Notifier < ActionMailer::Base

  def error_notification(error_msg,exception,request)
    recipients ['alerts@thedextrousweb.com']
    from       "the-server@learning.dev.thedextrousweb.com"
    subject    "Learning Rev: #{error_msg} #{exception.andand.class}"
    body       :message => error_msg, :exception => exception, :referer => request.env['HTTP_REFERER'], :useragentstring => request.env['HTTP_USER_AGENT'], :remote_ip => request.env['REMOTE_ADDR'], :requesturi => request.env['REQUEST_URI'], :host => request.env['HTTP_HOST']
  end

end
