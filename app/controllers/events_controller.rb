class EventsController < ApplicationController
  before_filter :ensure_filters
  
  def index
    @first_day_of_month = Time.parse("#{params[:month]} #{params[:year]}")
    @events = Event.find_by_month_with_filter_from_params(@first_day_of_month, params[:filter])
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
  
  def ensure_filters
    params[:filter] ||= {}
  end

end
