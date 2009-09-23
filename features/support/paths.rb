module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the homepage/
      '/'
    when /the new venue admin page/
      new_admin_venue_path
    when /venue admin index page/
      admin_venues_path
    when /the new event admin page/
      new_admin_event_path
    when /event admin index page/
      admin_events_path      
    when /the event duplicates page/
      duplicates_admin_events_path      
    when /the venue duplicates page/
      duplicates_admin_venues_path
    when /the events moderation page/ 
      moderations_admin_events_path
    when /the calendar for October 2009/
      events_by_month_path(2009, "October")
    when /the event page for "(.+)"/
      event = find_or_create(Event, :title => $1)
      event_path(event.start.year, event.start.month, event.start.day, event.slug)
    when /the event success page/
      events_success_path
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n"
    end
  end
end

World(NavigationHelpers)
