Given /^a valid venue called "([^\"]*)"$/ do |name|
  Venue.create!(:name => name, :postcode => "E11 1EE")
end
