Given /^a valid event called "([^\"]*)"$/ do |name|
  Event.create!(:title => name, :start => Date.today, :contact_name => "Test name", :contact_email_address => "test@test.com", :theme => "Event theme", :event_type => "event type", :published => true)
end

Given /^the event "([^\"]*)" is held at the venue "([^\"]*)"$/ do |title, venue_title|
  event = find_or_create(Event, :title => title)
  event.venue = find_or_create(Venue, :name => venue_title)
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

Given /^the event "([^\"]*)" is located at lat "([^\"]*)" and lng "([^\"]*)"$/ do |title, lat, lng|
  event = find_or_create(Event, :title => title)
  event.update_attribute(:lat, lat)
  event.update_attribute(:lng, lng)
end

Given /^the event "([^\"]*)" is not published yet$/ do |title|
  find_or_create(Event, :title => title).update_attribute(:published, false)
end

When /^we assume the user successfully picks "([^\"]*)" form autosuggest$/ do |title|
  venue = find_or_create(Venue, :name => title)
  set_hidden_field("event[location_id]", :to => venue.id) 
end
