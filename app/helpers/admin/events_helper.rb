module Admin::EventsHelper

  def next_event(event)
    Event.find(:first, :conditions => ["(published IS NULL OR published != 1) AND id > ?", event.id], :order => "id ASC")
  end

  def get_unpublished_message(unpublished_count)
    return "There are currently #{unpublished_count} unpublished events." if unpublished_count != 1

    "There is currently #{unpublished_count} unpublished event."
  end

  def get_duplicates_message(duplicates_count)
    return "There are currently #{duplicates_count} possible duplicate events." if duplicates_count == 1

    "There is currently #{duplicates_count} possibly duplicate event."
  end
end
