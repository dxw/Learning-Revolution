Then /^I should receive an events listing email$/ do
  Then "I should receive an email"
  When "I open the email"
  Then "I should see \"listing\" within the email subject"
end

Given /^I have requested an email of events filtered by the theme "([^\"]*)"$/ do |theme|
  Given "I am on the calendar for October 2009 filtered by the theme \"#{theme}\""
  When 'I follow "Email these events to me."'
  And 'I fill in "Email address" with "example@example.com"'
  And 'I press "Send"'
end

Given /^I have received the events listing email$/ do
  Then "I should receive an events listing email"
end

Given /^I have subscribed to updates about events filtered by the theme "([^\"]*)"$/ do |theme|
  Given "I have requested an email of events filtered by the theme \"#{theme}\""
  And "I have received the events listing email"
  When "I open the email"
  And "I follow \"subscription\" in the email"
end

When /^the daily email updates are sent$/ do
  EmailSubscription.deliver_all_updates!
end

Then /^I should receive an event update email$/ do
  Then "I should receive an email"
  When "I open the email with subject \"update\""
  Then "I should see \"update\" within the email subject"
end

Given /^I have received an event update email$/ do
  When "someone adds an event called \"Goose Juggling\" with the theme \"Sport and Physical Activity\""
  And "an administrator approves the event \"Goose Juggling\""
  And "the daily email updates are sent"
  Then "I should receive an event update email"
end
