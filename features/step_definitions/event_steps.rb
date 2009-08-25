Given /^a valid event called "([^\"]*)"$/ do |name|
  Event.create!(:title => name, :start => Date.today)
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
