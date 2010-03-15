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
    when /the calendar for October 2009 filtered by the theme "(.+)"/
      events_by_month_path(:year => 2009, :month => 'October', :filter => {:theme => $1, :location => ''})
    when /the calendar for October 2009/
      events_by_month_path(2009, "October")
    when /the event page for "(.+)"/
      event = find_or_create(Event, :title => $1)
      event_path(event.start.year, event.start.month, event.start.day, event.slug)
    when /the event success page/
      events_success_path
    when /the frequently asked questions page/
      '/frequently-asked-questions'
    when /about/
      '/about'
    when /the privacy policy/
      '/privacy-policy'
    when /the terms and conditions/
      '/terms-and-conditions'
    when /the copyright page/
      '/copyright'
    when /the promote your event page/
      '/promote-your-event'
    when /news/
      '/news'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n"
    end
  end
end

World(NavigationHelpers)
