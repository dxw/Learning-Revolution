# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers/all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def return_or_redirect_to(*args)
    unless params[:return_to].blank?
      redirect_to params[:return_to]
    else
      redirect_to(*args)
    end
  end
  
  def path_for_event(event)
    "/events/#{event.start.year}/#{Date::MONTHNAMES[event.start.month]}/#{event.start.day}/#{event.slug}"
  end
  
end
