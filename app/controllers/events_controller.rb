class EventsController < ApplicationController
  def index
    @first_day_of_month = Time.parse("#{params[:month]} #{params[:year]}")
    @events = Event.find_for_month(@first_day_of_month)
  end

  def show
  end

end
