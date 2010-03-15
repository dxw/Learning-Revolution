class Admin::AdminController < ApplicationController
  layout 'admin'
  before_filter :authenticate
  cache_sweeper :event_sweeper

  protected


  def index
    params[:filter] ||= {}
    params[:view] ||= 'calendar'

    @first_day_of_month = Time.parse("#{params[:month]} #{params[:year]}")
    if params[:view] == "map"
      set_map_bounds
      set_from_and_to_to_dates
      @venues = Venue.find_venues_by_event_params(params[:filter])
    else
      @events = Event.find_by_month_with_filter_from_params(@first_day_of_month, params[:filter])
      @event_counts = Event.counts_for_month(@first_day_of_month)
    end

  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "lr_admin" && password == "learning is fun!"
    end
  end
end
