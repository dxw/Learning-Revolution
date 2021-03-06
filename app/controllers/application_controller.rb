# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers/all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # uncomment this in development test validation on pages that need data POSTed.
  # self.allow_forgery_protection = false

  # adding this overrites the local method, so we can see the 404 and 500 pages
  # alias_method :rescue_action_locally, :rescue_action_in_public

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :set_page_title
  def set_page_title
    @page_title = AppConfig.site_name
  end
  def add_page_title(title)
    @page_title = @page_title += " : #{title}"
  end

  def return_or_redirect_to(*args)
    unless params[:return_to].blank?
      redirect_to params[:return_to]
    else
      redirect_to(*args)
    end
  end

  #
  # TODO
  #
  # This method needs to be modified to use the event URL structure specified in config/application.yml
  #

  def path_for_event(event, filters = nil, last_view = nil)
    return "/" unless event

    unless filters.nil?
      filters[:location] ||= ''
      filters[:theme] ||= ''
    end

    path = "/events/#{event.start.year}/#{Date::MONTHNAMES[event.start.month]}/#{event.start.day}/#{event.slug}?"

    path += "last_view=#{last_view}" unless last_view.nil? || last_view.empty?
    path += "&amp;filter%5Btheme%5D=#{URI.encode(filters[:theme])}&amp;filter%5Blocation%5D=#{URI.encode(filters[:location])}" unless filters.nil? || filters.empty?

    path
  end

  def current_events_path(options={})
    events_by_month_path(Time.zone.now.year, Time.zone.now.strftime('%B'), options)
  end

  def render_500(exception=nil)
    @status = 500
    render :template => 'error', :status => 500

    # Ignore
    return if exception.is_a? ActionController::MethodNotAllowed and request.env['HTTP_USER_AGENT'].include? 'Googlebot'

    Notifier.deliver_error_notification('500',exception,request)
  end

  def render_404(exception=nil)
    @status = 404
    render :template => 'error', :status => 404

    # Ignore
    return if request.env['HTTP_USER_AGENT'].start_with? 'Java/'
    return if request.env['HTTP_REFERER'].blank?
    return if request.env['REQUEST_URI'].include? 'MSOffice'
    return if request.env['REQUEST_URI'].include? '_vti_bin'
    File.read(File.join(RAILS_ROOT, 'config', '404ignore')).split("\n").each do |line|
      return if request.env['REQUEST_URI'].match Regexp.compile(line)
    end

    Notifier.deliver_error_notification('404',exception,request)
  end

  def rescue_action_in_public(exception)
    if exception.is_a? ActionController::RoutingError
      render_404(exception)
    else
      render_500(exception)
    end
  end

end
