Given /^a valid event called "([^\"]*)"$/ do |name|
  Event.create!(:title => name, :start => Date.today)
end