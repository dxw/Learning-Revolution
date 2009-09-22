# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def return_to_hidden_field
    hidden_field_tag "return_to", params[:return_to]
  end
    
  def path_for_event(event, filters = nil)
    controller.path_for_event(event, filters)
  end
  
  def url_for_event(event)
    controller.url_for_event(event)
  end
  
  def current_events_path(options={})
    controller.current_events_path(options)
  end

  def current_filter_description
    
    if params[:filter][:theme].nil? && params[:filter][:location].nil? then
      s = "Click \"Find Events\" to get started" 
    else
      s = 'Now showing all'
      unless params[:filter][:theme].blank?
        s += " <span class='keyword'>"
        s += params[:filter][:theme]
        s += "</span>"
      end
      s += ' events'
      unless params[:filter][:location].blank?
        s += ' happening within 5 miles of <span class="keyword">'
        s += params[:filter][:location].upcase
        s += '</span>'
      end
    end
    
    s
  end
end
