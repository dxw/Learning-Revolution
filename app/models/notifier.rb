class Notifier < ActionMailer::Base

  def error_notification(error_msg,exception,request)
    recipients []
    from       "x@example.org"
    subject    "Event Thing: #{error_msg} #{exception.andand.class}"
    body       :message => error_msg, :exception => exception, :referer => request.env['HTTP_REFERER'], :useragentstring => request.env['HTTP_USER_AGENT'], :remote_ip => request.env['REMOTE_ADDR'], :requesturi => request.env['REQUEST_URI'], :host => request.env['HTTP_HOST'], :request => request
  end

end
