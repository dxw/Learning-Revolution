Feature: Adding an event
  In order to add the event I'm running 
  As a user
  I should be able to be able to add a new event

  Scenario: Adding a valid event with no venue
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    And there should be 1 Event in the database
    And there should be 0 Venue in the database
    And there should be an Event whose start datetime is "2009-10-23 11:20"
    And there should be an Event whose end datetime is "2009-10-23 12:20"
    And there should be an Event whose title is "event title"
    And there should be an Event whose event_type is "Class"
    And there should be an Event whose theme is "Food and Cookery"
    And there should be an Event whose description is "event description"
    And there should be an Event whose organisation is "BIS"
    And there should be an Event whose contact_name is "event organiser"
    And there should be an Event whose contact_phone_number is "020 8547 3847"
    And there should be an Event whose contact_email_address is "contact@test.com"
  
  Scenario: Adding an invalid event with end time < start time
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "10" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "1 error prohibited this new event from being save"
    And I should see "The event can't finish before it's begun"
    And the page is valid XHTML
    And there should be 0 Event in the database
  
  Scenario: Adding a valid event with no end time set
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    And there should be 1 Event in the database
    And there should be 0 Venue in the database
  
  Scenario: Adding an invalid event with no venue
    When I go to the calendar for October 2009
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "3 errors prohibited this new event from being save"
    And I should see "Event name can't be blank"
    And I should see "Contact name can't be blank"
    And I should see "Contact email address can't be blank"
    And the page is valid XHTML
    And there should be 0 Event in the database
  
  Scenario: Adding a valid event from the calendar page with a new venue
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "E11 1PB"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We don't currently have any venues listed in this postcode"
    And the page is valid XHTML
    When I fill in "Venue name" with "Venue name"
    And I fill in "Address Line 1" with "Address 1 name"
    And I fill in "Address Line 2" with "Address 2 name"
    And I fill in "Address Line 3" with "Address 3 name"
    And I fill in "City" with "City name"
    And I fill in "County" with "County name"
    And I press "Add this venue for my event"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "Venue name"
    And I should see "Address 1 name"
    And I should see "Address 2 name"
    And I should see "Address 3 name"
    And I should see "City name"
    And I should see "County name"
    And I should see "E11 1PB"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    Then there should be 1 Event in the database
    And there should be 1 Venue in the database
    And I am on the calendar for October 2009

  Scenario: Adding an invalid event from the calendar page
    When I go to the calendar for October 2009
    And I fill in "Event Postcode" with "E11 1PB"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "3 errors prohibited this new event from being save"
    And I should see "Event name can't be blank"
    And I should see "Contact name can't be blank"
    And I should see "Contact email address can't be blank"
    And the page is valid XHTML
    And there should be 0 Event in the database
  
  Scenario: Adding a valid event but forgetting post code
    When I go to the calendar for October 2009
    And I check "I accept the"
    And I press "Continue"
    Then I should see "Postcode can't be blank"
    And the page is valid XHTML
  
  Scenario: Adding a valid event but an malformed post code
    When I go to the calendar for October 2009
    And I fill in "Event Postcode" with "xxxxxxxxxxx"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "The postcode you entered seems to be invalid"
    And the page is valid XHTML
  
  Scenario: Adding a valid event but a non-existent well formed post code
    When I go to the calendar for October 2009
    And I fill in "Event Postcode" with "SW0z 0zz"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We couldn't find anywhere with this postcode"
    And the page is valid XHTML
  
  Scenario: Adding a valid event to an existing venue
    Given a valid venue called "Church hall"
    And the venue "Church hall" has the post code "TR18 5EG"
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "TR18 5EG"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We may already have the details of your venue"
    When I press "Choose this venue"
    Then I should see "You're about to add this this event to the listings"
    And the page is valid XHTML
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "Church hall"
    And I should see "TR18 5EG"
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    And there should be 1 Event in the database
    And there should be 1 Venue in the database
    And I am on the calendar for October 2009

  Scenario: Adding a valid event when there are multiple similar venues
    Given a valid venue called "Church hall"
    And the venue "Church hall" has the post code "TR18 5EG"
    And a valid venue called "School hall"
    And the venue "School hall" has the post code "TR18 5EG"
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I fill in "Start time" with "October 23, 2004 11:20"
    And I fill in "End time" with "October 23, 2004 12:20"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "TR18 5EG"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We may already have the details of your venue"
    And I should see "Church hall"
    And I should see "School hall"
    And the page is valid XHTML

  Scenario: Adding a valid event to a new venue, when there's an existing venue with same post code
    Given a valid venue called "Church hall"
    And the venue "Church hall" has the post code "TR18 5EG"
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "24th" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "TR18 5EG"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We may already have the details of your venue"
    When I fill in "Venue name" with "Venue name"
    And I fill in "Address Line 1" with "Address 1 name"
    And I fill in "Address Line 2" with "Address 2 name"
    And I fill in "Address Line 3" with "Address 3 name"
    And I fill in "City" with "City name"
    And I fill in "County" with "County name"
    And I press "Add this venue for my event"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 24 October 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    And there should be 1 Event in the database
    And there should be 2 Venue in the database
    And I am on the calendar for October 2009

  Scenario: Adding a valid event with no venue
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    And there should be 1 Event in the database
    And there should be 0 Venue in the database
  
  Scenario: Adding an invalid event with end time < start time
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "10" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "1 error prohibited this new event from being save"
    And I should see "The event can't finish before it's begun"
    And the page is valid XHTML
    And there should be 0 Event in the database
  
  Scenario: Adding a valid event with no end time set
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    And there should be 1 Event in the database
    And there should be 0 Venue in the database
  
  Scenario: Adding an invalid event with no venue
    When I go to the calendar for October 2009
    And I check "This event has no location"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "3 errors prohibited this new event from being save"
    And I should see "Event name can't be blank"
    And I should see "Contact name can't be blank"
    And I should see "Contact email address can't be blank"
    And the page is valid XHTML
    And there should be 0 Event in the database

  Scenario: Adding a valid event but forgetting T&C
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I check "This event has no location"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I press "Continue"
    Then I should see "1 error prohibited this new event from being save"
    And I should see "You must accept the terms and conditions"
    And the page is valid XHTML
    And there should be 0 Event in the database

  Scenario: Adding a valid event from the calendar page with a new, invalid venue, then fixing it and resubmitting
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "E11 1PB"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We don't currently have any venues listed in this postcode"
    And the page is valid XHTML
    When I fill in "Address Line 1" with "Address 1 name"
    And I fill in "Address Line 2" with "Address 2 name"
    And I fill in "Address Line 3" with "Address 3 name"
    And I fill in "City" with "City name"
    And I fill in "County" with "County name"
    And I press "Add this venue for my event"
    Then I should see "1 error prohibited this new venue from being save"
    And I should see "Name can't be blank"
    And the page is valid XHTML
    And there should be 0 Event in the database
    And there should be 0 Venue in the database
    Then I fill in "Venue name" with "Venue name"
    And I press "Add this venue for my event"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "Venue name"
    And I should see "E11 1PB"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    Then there should be 1 Event in the database
    And there should be 1 Venue in the database
    And I am on the calendar for October 2009

  Scenario: Adding a valid event from the calendar page with a new, invalid venue, then fixing it and resubmitting, and editing, and resubmitting
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "E11 1PB"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We don't currently have any venues listed in this postcode"
    And the page is valid XHTML
    When I fill in "Address Line 1" with "Address 1 name"
    And I fill in "Address Line 2" with "Address 2 name"
    And I fill in "Address Line 3" with "Address 3 name"
    And I fill in "City" with "City name"
    And I fill in "County" with "County name"
    And I press "Add this venue for my event"
    Then I should see "1 error prohibited this new venue from being save"
    And I should see "Name can't be blank"
    And the page is valid XHTML
    And there should be 0 Event in the database
    And there should be 0 Venue in the database
    Then I fill in "Venue name" with "Venue name"
    And I press "Add this venue for my event"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "Venue name"
    And I should see "E11 1PB"
    And the page is valid XHTML
    When I press "Edit this event"
    Then I check "This event has no location"
    And I press "Continue"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "This event has no location"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    Then there should be 1 Event in the database
    And there should be 0 Venue in the database
    And I am on the calendar for October 2009

  Scenario: Adding a valid event from the calendar page with an existing venue, going back and resubmitting
    Given a valid venue called "MyName"
    And the venue "MyName" has the post code "E11 1PB"
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "E11 1PB"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We may already have"
    And the page is valid XHTML
    When I press "Choose this venue"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "MyName"
    And I should see "E11 1PB"
    And the page is valid XHTML
    When I press "Edit this event"
    And I press "Continue"
    When I press "Choose this venue"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "MyName"
    And I should see "E11 1PB"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    Then there should be 1 Event in the database
    And there should be 1 Venue in the database
    And I am on the calendar for October 2009

  Scenario: Adding a valid event from the calendar page with a new venue, going back and resubmitting
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "E11 1PB"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We don't currently"
    And the page is valid XHTML
    When I fill in "Venue name" with "namae"
    And I fill in "Address Line 1" with "adoresu"
    When I press "Add this venue for my event"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "namae"
    And I should see "adoresu"
    And I should see "E11 1PB"
    And the page is valid XHTML
    When I press "Edit this event"
    And I press "Continue"
    When I press "Add this venue for my event"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And I should see "namae"
    And I should see "adoresu"
    And I should see "E11 1PB"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    Then there should be 1 Event in the database
    And there should be 1 Venue in the database
    And I am on the calendar for October 2009

  Scenario: Adding a new event with a venue identical to an existing venue
    Given a valid venue called "Church hall"
    And the venue "Church hall" has the post code "TR18 5EG"
    When I go to the calendar for October 2009
    And I fill in "Event name" with "event title"
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "24th" from "endday"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Event Postcode" with "TR18 5EG"
    And I check "I accept the"
    And I press "Continue"
    Then I should see "We may already have the details of your venue"
    When I fill in "Venue name" with "Church hall"
    And I press "Add this venue for my event"
    Then I should see "You're about to add this this event to the listings"
    And I should see "event title"
    And I should see "event description"
    And I should see "23 October 11:20AM"
    And I should see "until 24 October 12:20PM"
    And I should see "BIS"
    And I should see "event organiser"
    And I should see "020 8547 3847"
    And I should see "contact@test.com"
    And the page is valid XHTML
    When I press "Add this event to the listings"
    Then I am on the event success page
    And the page is valid XHTML
    And there should be 1 Event in the database
    And there should be 1 Venue in the database
    And I am on the calendar for October 2009
