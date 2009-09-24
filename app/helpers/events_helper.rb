module EventsHelper

  def filter_check_button_path
    params[:filter].blank? ? '/images/buttons/bt_search_for_events.gif' : '/images/buttons/bt_refine_this_search.gif'
  end
  
  def event_accessibility_info(event)
    info = "<span class='hidden'>[#{event.start.day}/#{event.start.month}/#{event.start.year}"
    info += ", #{event.venue.postcode}]" unless event.venue.nil?
    info += "</span>"
  end
  
  def prev_link(day, filters, last_view) 
    return make_link(day-1, "&laquo; Prev day", filters, last_view) if day > 1
    
    ''
  end
  
  def next_link(day, filters, last_view)
    return make_link(day+1, "Next day &raquo;", filters, last_view) if day < 31
    
    ''
  end
  
  private 
  def make_link(day, text, filters, last_view)
    link = "/events/2009/October/#{day-1}?last_view=#{last_view}"
      
    unless filters.nil? || filters.empty?
      link += "&amp;filter[theme]=#{URI.encode(filters[:theme])}&amp;filter[location]=#{URI.encode(filters[:location])}"
    end
    
    link_to(text, link, :class => 'trigger')
  end
end
