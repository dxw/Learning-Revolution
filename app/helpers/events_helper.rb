module EventsHelper

  def filter_check_button_path
    params[:filter].blank? ? '/images/buttons/bt_search_for_events.gif' : '/images/buttons/bt_refine_this_search.gif'
  end
  
  def event_accessibility_info(event)
    info = "<span class='hidden'>[#{event.start.day}/#{event.start.month}/#{event.start.year}"
    info += ", #{event.venue.postcode}]" unless event.venue.nil?
    info += "</span>"
  end
  
  def prev_link(event, filters, last_view)
    target = Event.step_backwards_from(event)
    return make_link(target, "&laquo; Earlier", filters, last_view) unless target.nil?

    ''
  end
  
  def next_link(event, filters, last_view)
    target = Event.step_forwards_from(event)
    return make_link(target, "Later &raquo;", filters, last_view) unless target.nil?
    ''
  end
  
  private 
  def make_link(event, text, filters, last_view)
    link_to(text, path_for_event(event, filters, last_view), :class => 'trigger')
  end
  
  def make_venue_ajax_url(venue, filters)
    link = "/venues/#{venue.id}?last_view=map"
    link += "&amp;filter[theme]=#{URI.encode(filters[:theme])}&amp;filter[location]=#{URI.encode(filters[:location])}" unless filters.nil? || filters.empty?
  end
end
