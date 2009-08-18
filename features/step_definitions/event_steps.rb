Given /^a valid event called "([^\"]*)"$/ do |name|
  Event.create!(:title => name)
end