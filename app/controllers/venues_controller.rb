class VenuesController < ApplicationController
  def events
    params[:filter] ||= {}
    venue = Venue.find(params[:venue_id])
    events = venue.find_events_by_event_params(params[:filter])
    respond_to do |format|
      format.js {render :json => events.collect{|event| {"title" => event.title, "url" => path_for_event(event, params[:filter].merge({:last_view => 'map'}))}}}
    end
  end

end
