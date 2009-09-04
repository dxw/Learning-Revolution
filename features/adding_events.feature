Feature: Adding an event
  In order to add the event I'm running 
  As a user
  I should be able to be able to add a new event
  
  Scenario: Adding a valid event from the calendar page with a new venue
    When I go to the calendar for October 2009
    And I fill in "Title" with "event title"
    
    And I fill in "Postcode" with "E11 1PB"
    And I fill in "Venue name" with "Venue name"
    And I fill in "Address Line 1" with "Address 1 name"
    And I fill in "Address Line 2" with "Address 2 name"
    And I fill in "Address Line 3" with "Address 3 name"
    And I fill in "City" with "City name"
    And I fill in "County" with "County name"
    
    And I select "Class" from "event_event_type"
    And I select "Food and Cookery" from "Category"
    And I fill in "Description" with "event description"
    And I fill in "From" with "October 23, 2004 11:20"
    And I fill in "until" with "October 23, 2004 12:20"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I press "Submit this event"
    
    Then I should see "Event created succesfully"
    And there should be 1 Event in the database
    And there should be 1 Venue in the database
    And I am on the calendar for October 2009

  # Scenario: Adding a valid event from the calendar page with an invalid new venue
  #   When I go to the calendar for October 2009
  #   And I fill in "Title" with "event title"
  #   And I select "Class" from "event_event_type"
  #   And I select "Food and Cookery" from "Category"
  #   And I fill in "Description" with "event description"
  #   And I fill in "From" with "October 23, 2004 11:20"
  #   And I fill in "until" with "October 23, 2004 12:20"
  #   And I fill in "Organisation" with "BIS"
  #   And I fill in "Contact Name" with "event organiser"
  #   And I fill in "Contact Phone Number" with "020 8547 3847"
  #   And I fill in "Contact Email Address" with "contact@test.com"
  #   And I press "Submit this event"
  #   Then I should see "FAIL"
    
