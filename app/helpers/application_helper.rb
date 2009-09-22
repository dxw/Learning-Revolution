# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def return_to_hidden_field
    hidden_field_tag "return_to", params[:return_to]
  end
    
  def path_for_event(event)
    controller.path_for_event(event)
  end
  
  def url_for_event(event)
    controller.url_for_event(event)
  end
  
  def current_events_path(options={})
    controller.current_events_path(options)
  end

  def current_filter_description
    
    if params[:filter][:theme].blank? && params[:filter][:location].blank? then
      s = "Click \"Find Events\" to get started" 
    else
      s = 'Now showing all <span class="keyword">'
      s += params[:filter][:event_type].blank? ? "events" : params[:filter][:event_type].downcase.pluralize
      s += '</span>'
      unless params[:filter][:theme].blank?
        s += " in <span class='keyword'>"
        s += params[:filter][:theme]
        s += "</span>"
      end
      unless params[:filter][:location].blank?
        s += ' happening within 5 miles of <span class="keyword">'
        s += params[:filter][:location].upcase
        s += '</span>'
      end
    end
    
    s
  end
end
