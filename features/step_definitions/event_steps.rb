Given /^a valid event called "([^\"]*)"$/ do |name|
  e = Event.new(:title => name, :start => Date.today, :contact_name => "Test name", :contact_phone_number => "01142888888", :contact_email_address => "test@test.com", :theme => "Event theme", :event_type => "event type", :published => true)
  e.possible_duplicate?
  e.save!
end

Given /^the event "([^\"]*)" is held at the venue "([^\"]*)"$/ do |title, venue_title|
  event = find_or_create(Event, :title => title)
  event.venue = find_or_create(Venue, :name => venue_title, :postcode => "E11 1PB")
  event.save!
end

Given /^the event "([^\"]*)" starts on "([^\"]*)"$/ do |title, start|
  find_or_create(Event, :title => title).update_attribute(:start, start)
end

Given /^the event "([^\"]*)" has the theme "([^\"]*)"$/ do |title, theme|
  find_or_create(Event, :title => title).update_attribute(:theme, theme)
end

Given /^the event "([^\"]*)" has the type "([^\"]*)"$/ do |title, type|
  find_or_create(Event, :title => title).update_attribute(:event_type, type)
end

Given /^the event "([^\"]*)" has the description "([^\"]*)"$/ do |title, description|
  find_or_create(Event, :title => title).update_attribute(:description, description)
end

Given /^the event "([^\"]*)" is located at lat "([^\"]*)" and lng "([^\"]*)"$/ do |title, lat, lng|
  event = find_or_create(Event, :title => title)
  event.update_attribute(:lat, lat)
  event.update_attribute(:lng, lng)
end

Given /^the event "([^\"]*)" has no location$/ do |title|
  event = find_or_create(Event, :title => title)
  event.update_attribute(:lat, nil)
  event.update_attribute(:lng, nil)
end

Given /^the event "([^\"]*)" is not published yet$/ do |title|
  find_or_create(Event, :title => title).update_attribute(:published, false)
end

When /^we assume the user successfully picks "([^\"]*)" form autosuggest$/ do |title|
  venue = find_or_create(Venue, :name => title)
  set_hidden_field("event[location_id]", :to => venue.id)
end

Then /^I should see the map$/ do
  response.should have_selector('div', :id => 'events_map')
end

When /^someone adds an event called "([^\"]*)" with the theme "([^\"]*)"$/ do |title, theme|
  # Taken from adding_events.feature
  When "I go to the calendar for October 2009"
  And "I fill in \"Event name\" with \"#{title}\""
  And "I select \"Class\" from \"event_event_type\""
  And "I select \"#{theme}\" from \"Category\""
  And "I fill in \"Description\" with \"event description\""
  And "I select \"11\" from \"starthour\""
  And "I select \"20\" from \"startminute\""
  And "I select \"23rd\" from \"startday\""
  And "I select \"12\" from \"endhour\""
  And "I select \"20\" from \"endminute\""
  And "I select \"23rd\" from \"endday\""
  And "I fill in \"Organisation\" with \"BIS\""
  And "I fill in \"Contact Name\" with \"event organiser\""
  And "I fill in \"Contact Phone Number\" with \"020 8547 3847\""
  And "I fill in \"Contact Email Address\" with \"contact@test.com\""
  And "I check \"This event occurs online or has no physical location\""
  And "I check \"I accept the\""
  And "I press \"Continue\""
  And "I press \"Add this event to the listings\""
end

When /^an administrator approves the event "([^\"]*)"$/ do |title|
  # Taken from event_admin.feature
  Given "I am logged in"
  When "I go to the events moderation page"
  Then "I should see \"#{title}\""
  When "I press \"Approve\""
end
