Feature: Event admin
  In order to keep the event data clean
  As an admin
  I should be able to be able to add, edit and delete events
  
  Scenario: Adding a valid event
    When I go to the event admin index page
    And I follow "New event"
    And I fill in "Title" with "event title"
    And I fill in "Description" with "event description"
    And I fill in "Theme" with "event theme"
    And I fill in "Type" with "event type"
    And I fill in "Stage" with "event stage"
    And I select "November 23, 2004 11:20" as the "Start" date and time
    And I select "November 23, 2004 12:20" as the "End" date and time
    And I fill in "Cost" with "£1.50"
    And I fill in "Min Age" with "13"
    And I fill in "Venue" with "London"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I fill in "Further Information" with "There isn't really any further info"
    And I fill in "Additional Notes" with "Additional Notes"
    And I check "Published"
    And I fill in "Picture" with "http://www.google.co.uk/intl/en_uk/images/logo.gif"
    And I check "Featured"
    And I press "Create"
    Then I should see "Event created successfully"
    And I should see "event title"
    And I am on the event admin index page
    
  Scenario: Submitting an empty form
    When I go to the event admin index page
    And I follow "New event"
    And I press "Create"
    Then I should see "error prohibited this event from being saved"
    And I should see "Title can't be blank"
    And I am on the event admin index page
  
  Scenario: Editing a valid event
    Given a valid event called "event 1"
    When I go to the event admin index page
    And I follow "event 1"
    And I fill in "Title" with "New event title"
    And I press "Save"
    Then I should see "Event saved successfully"
    And I should see "New event title"
    And I am on the event admin index page
    
  Scenario: Removing the new event in a duplicate
    Given a valid event called "event 1"
    And a valid event called "event 2"
    When I go to the event duplicates page
    Then I should see "event 1"
    And I should see "event 2"
    When I press "Remove new event"
    Then I should see "event 2 was deleted"
    And I should not see "event 1"

  Scenario: Removing the original event in a duplicate
    Given a valid event called "event 1"
    And a valid event called "event 2"
    When I go to the event duplicates page
    Then I should see "event 1"
    And I should see "event 2"
    When I press "Remove original event"
    Then I should see "event 1 was deleted"
    And I should not see "event 2"
    