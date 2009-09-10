Given /^a valid venue called "([^\"]*)"$/ do |name|
  Venue.create!(:name => name, :postcode => "E11 1EE")
end

Given /^the venue "([^\"]*)" has the post code "([^\"]*)"$/ do |name, postcode|
  find_or_create(Venue, :name => name).update_attribute(:postcode, postcode)
end