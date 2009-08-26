Given /^a valid event called "([^\"]*)"$/ do |name|
  Event.create!(:title => name, :start => Date.today, :venue => Venue.new)
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
