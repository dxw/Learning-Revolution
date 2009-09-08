Feature: Viewing events
  As a user
  I should be view the details page of each event
  In order to see important info about each event
  So that I can attend

  Scenario: Viewing an event with a venue
    Given a valid event called "Festival of Ideas"
    And a valid venue called "Town Hall"
    And the event "Festival of Ideas" is held at the venue "Town Hall"
    And I go to the event page for "Festival of Ideas"
    Then I should see "Festival of Ideas"

  Scenario: Viewing an event without a venue
    Given a valid event called "Festival of Ideas"
    And I go to the event page for "Festival of Ideas"
    Then I should see "Festival of Ideas"
