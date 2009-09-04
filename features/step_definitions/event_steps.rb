Given /^a valid event called "([^\"]*)"$/ do |name|
  Event.create!(:title => name, :start => Date.today, :venue => Venue.create!(:name => "venue", :postcode => "E11 1PB"))
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

When /^we assume the user successfully picks "([^\"]*)" form autosuggest$/ do |title|
  venue = find_or_create(Venue, :name => title)
  set_hidden_field("event[location_id]", :with => venue.id) 
end
