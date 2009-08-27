Feature: Event admin
  In order to view the events
  As a user
  I should be view and filter events relevant to me
  
  Scenario: Viewing an unfiltered calendar
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    When I go to the calendar for October 2009
    Then I should see "Octoberfest" in the calendar on day "12"

  Scenario: Viewing a calendar filtered by theme
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" has the theme "Food and Cookery"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "12th October 2009 12:00"
    And the event "Spanish Guitar" has the theme "Languages and Travel"
    When I go to the calendar for October 2009
    And I select "Food and Cookery" from "Related to"
    And I press "Search"
    And debugger
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Spanish Guitar"

  Scenario: Viewing a calendar filtered by type and theme
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" has the theme "Food and Cookery"
    And the event "Octoberfest" has the type "Class"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "12th October 2009 12:00"
    And the event "Spanish Guitar" has the theme "Food and Cookery"
    And the event "Spanish Guitar" has the type "Lesson"
    When I go to the calendar for October 2009
    And I select "Food and Cookery" from "Related to"
    And I select "Class" from "Type"
    And I press "Search"
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Spanish Guitar"

@current
  Scenario: Viewing a calendar filtered by location
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" is located at lat "0" and lng "0"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "12th October 2009 12:00"
    And the event "Spanish Guitar" is located at lat "50" and lng "50"
    When I go to the calendar for October 2009
    And I fill in "Location" with "SW1A 1AA"
    And I press "Search"
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Spanish Guitar"
    