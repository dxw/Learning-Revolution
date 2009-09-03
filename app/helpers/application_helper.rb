# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def return_to_hidden_field
    hidden_field_tag "return_to", params[:return_to]
  end
  
  
  #
  # TODO
  #
  # These methods need to be modified to use the event URL structure specified in config/application.yml
  #
  
  def path_for_event(event)
    controller.path_for_event(event)
  end
  
  def url_for_event(event)
    controller.url_for_event(event)
  end
  
  def current_events_path(options={})
    controller.current_events_path(options)
  end
  
  #
  # End TODO
  #
  
end
