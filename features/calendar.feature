Feature: Event admin
  In order to view the events
  As a user
  I should be view and filter events relevant to me
  
  Scenario: Viewing an unfiltered calendar
    Given a valid event called "Octoberfest"
    When I go to the calendar for October 2009
    Then I should see "This site generates customised calendars of events during the Festival of Learning. Here's how to use it"
    And I should not see "Octoberfest"
    And the page is valid XHTML

  Scenario: Viewing a calendar filtered by theme
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" has the theme "Food and Cookery"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "12th October 2009 12:00"
    And the event "Spanish Guitar" has the theme "Languages and Travel"
    And a valid event called "Secret Event"
    And the event "Secret Event" starts on "12th October 2009 12:00"
    And the event "Secret Event" has the theme "Food and Cookery"
    And the event "Secret Event" is not published yet
    When I go to the calendar for October 2009
    And I select "Food and Cookery" from "Area of Interest"
    And I press "Search For Events"
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Spanish Guitar"
    And I should not see "Secret Event"
    And the page is valid XHTML

  Scenario: Viewing a calendar filtered by location
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" is located at lat "51.584911" and lng "0.02591"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "12th October 2009 12:00"
    And the event "Spanish Guitar" is located at lat "50" and lng "50"
    And a valid event called "Secret Event"
    And the event "Secret Event" is not published yet
    And the event "Secret Event" starts on "12th October 2009 12:00"
    And the event "Secret Event" is located at lat "51.584911" and lng "0.02591"
    When I go to the calendar for October 2009
    And I fill in "Postcode" with "E11 1PB GB"
    And I press "Search For Events"
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should not see "Spanish Guitar"
    And I should not see "Secret Event"
    And the page is valid XHTML
    
