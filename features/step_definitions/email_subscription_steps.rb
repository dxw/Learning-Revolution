Then /^I should receive an events listing email$/ do
  Then "I should receive an email"
  When "I open the email"
  Then "I should see \"listing\" within the email subject"
end

Given /^I have requested an email of events filtered by the theme "([^\"]*)"$/ do |arg1|
  Given "I am on the calendar for October 2009 filtered by the theme \"Food and Cookery\""
  When 'I follow "Send me these events as email."'
  And 'I fill in "Email address" with "example@example.com"'
  And 'I press "Send"'
end

Given /^I have received the events listing email$/ do
  Then "I should receive an events listing email"
end

Given /^I have subscribed to updates about events filtered by the theme "([^\"]*)"$/ do |arg1|
  pending
end

When /^the daily email updates are sent$/ do
  pending
end

Then /^I should receive an event update email$/ do
  pending
end

Given /^I have received an event update email$/ do
  pending
end
