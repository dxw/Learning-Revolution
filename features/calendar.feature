Feature: Event admin
  In order to view the events
  As a user
  I should be view and filter events relevant to me
  
  @current
  Scenario: Viewing an unfiltered calendar
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And a valid event called "Secret Event"
    And the event "Secret Event" starts on "12th October 2009 12:00"
    And the event "Secret Event" is not published yet
    When I go to the calendar for October 2009
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Secret Event"

  Scenario: Viewing a calendar filtered by theme
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" has the theme "Food and Cookery"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "12th October 2009 12:00"
    And the event "Spanish Guitar" has the theme "Languages and Travel"
    When I go to the calendar for October 2009
    And I select "Food and Cookery" from "Theme"
    And I press "Search For Events"
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
    And I select "Food and Cookery" from "Theme"
    And I select "Class" from "Event Type"
    And I press "Search For Events"
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Spanish Guitar"

  Scenario: Viewing a calendar filtered by location
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" is located at lat "51.584911" and lng "0.02591"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "12th October 2009 12:00"
    And the event "Spanish Guitar" is located at lat "50" and lng "50"
    When I go to the calendar for October 2009
    And I fill in "Location" with "E11 1PB GB"
    And I press "Search For Events"
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Spanish Guitar"
    