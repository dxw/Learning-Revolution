module EventsHelper

  def filter_check_button_path
    params[:filter].blank? ? '/images/buttons/bt_search_for_events.gif' : '/images/buttons/bt_refine_this_search.gif'
  end
  
  def event_accessibility_info(event)
    info = "<span class='hidden'>[#{event.start.day}/#{event.start.month}/#{event.start.year}"
    info += ", #{event.venue.postcode}]" unless event.venue.nil?
    info += "</span>"
  end
end
