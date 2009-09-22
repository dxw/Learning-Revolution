# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers/all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # uncomment this in development test validation on pages that need data POSTed.
  # self.allow_forgery_protection = false

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  unless ActionController::Base.consider_all_requests_local
    rescue_from RuntimeError, :with => :render_500
  end
  
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
  
  def path_for_event(event, filters = nil)
    return "/" unless event
    
    path = "/events/#{event.start.year}/#{Date::MONTHNAMES[event.start.month]}/#{event.start.day}/#{event.slug}"
    
    unless filters.nil?
      path += "?filter[theme]=#{URI.encode(filters[:theme])}&amp;filter[location]=#{URI.encode(filters[:location])}&amp;last_view=#{filters[:last_view]}"
    end
    
    path
  end
  
  def url_for_event(event)
    event_url(event.start.year, event.start.month, event.start.day, event.slug)
  end
  
  def current_events_path(options={})
    events_by_month_path(2009, "October", options)
  end

  def render_500
    @status = 500
    render :template => 'error', :status => 500
  end
  
end
