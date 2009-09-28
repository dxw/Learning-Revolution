module Admin::EventsHelper
  
  def next_event(event)
    Event.find(:first, :conditions => ["(published IS NULL OR published != 1) AND id > ?", event.id], :order => "id ASC")
  end
end
