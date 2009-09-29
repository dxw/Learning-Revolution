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
    @page_title = "Learning Revolution"
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
    
    path = "/events/#{event.start.year}/#{Date::MONTHNAMES[event.start.month]}/#{event.start.day}/#{event.slug}?"
    
    path += "last_view=#{last_view}" unless last_view.nil? || last_view.empty?
    path += "&amp;filter[theme]=#{URI.encode(filters[:theme])}&amp;filter[location]=#{URI.encode(filters[:location])}" unless filters.nil? || filters.empty?
    
    path
  end
  
  def url_for_event(event)
    event_url(event.start.year, event.start.month, event.start.day, event.slug)
  end
  
  def current_events_path(options={})
    events_by_month_path(2009, "October", options)
  end

  def render_500(exception=nil)
    @status = 500
    render :template => 'error', :status => 500
    Notifier.deliver_error_notification('500',exception,request)
  end
  
  def render_404(exception=nil)
    @status = 404
    render :template => 'error', :status => 404
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
