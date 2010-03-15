class VenuesController < ApplicationController
  def events
    params[:filter] ||= {}
    venue = Venue.find(params[:venue_id])
    events = venue.find_events_by_event_params(params[:filter])
    respond_to do |format|
      format.js {render :json => events.collect{|event| {"title" => event.title, "url" => path_for_event(event, params[:filter].merge({:last_view => 'map'}))}}}
    end
  end

  def show
    respond_to do |format|
      params[:filter] ||= {}
      venue = Venue.find(params[:venue_id])
      format.js {render :json => [venue].collect{|venue| {"title" => venue.name, "address_1" => venue.address_1, "postcode" => venue.postcode}}}
    end
  end

  def venue_for_map
      params[:filter] ||= {}

      @venue = Venue.find(params[:venue_id])
      @filters = params[:filter]

      render :partial => 'events/events_at_a_venue'
  end
end
