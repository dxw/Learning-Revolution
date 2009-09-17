module EventsHelper

  def filter_check_button_path
    params[:filter].blank? ? '/images/buttons/bt_search_for_events.gif' : '/images/buttons/bt_refine_this_search.gif'
  end
end
