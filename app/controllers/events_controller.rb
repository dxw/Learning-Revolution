class EventsController < ApplicationController
  def index
    params[:filter] ||= {}
    @first_day_of_month = Time.parse("#{params[:month]} #{params[:year]}")
    @events = Event.find_for_month_with_filter(@first_day_of_month, params[:filter])
    @event_counts = Event.counts_for_month(@first_day_of_month)
  end

  def show
    @event = Event.find_by_slug(params[:id])
    fix_path
  end
  
  private
  
  def fix_path
    redirect_to path_for_event(@event) unless request.path == path_for_event(@event)
  end

end
