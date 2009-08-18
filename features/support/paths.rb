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
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n"
    end
  end
end

World(NavigationHelpers)
