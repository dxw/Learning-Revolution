Given /^a valid location called "([^\"]*)"$/ do |name|
  Location.create!(:name => name, :postcode => "E11 1EE")
end
