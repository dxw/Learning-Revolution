# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def return_to_hidden_field
    hidden_field_tag "return_to", params[:return_to]
  end
    
  def path_for_event(event, filters = nil, last_view = 'calendar')
    controller.path_for_event(event, filters, last_view)
  end
  
  def url_for_event(event, options={})
    event_url(event.start.year, event.start.month, event.start.day, event.slug, options)
  end
  
  def current_events_path(options={})
    controller.current_events_path(options)
  end

  def current_filter_description
    if params[:filter][:theme].nil? && params[:filter][:location].nil? then
      "Click <em>find events in your area</em> to get started" 
    else
      "Now showing " + current_filter_core_description
    end
  end
  
  def current_filter_core_description
    s = 'all'
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
    s
  end
end

module ActionView::Helpers::FormHelper
  def text_field(object_name, method, options = {})
    object = options.andand[:object]
    value = options[method]
    value ||= object.andand[method]
    value ||= params[object_name].andand[method]
    "<span class='#{ object.andand.errors.andand[method] ? 'fieldWithErrors' : '' }'><input type='text' id='#{object_name}_#{method}' name='#{object_name}[#{method}]' class='text input' value='#{value}' /></span>"
  end
end
