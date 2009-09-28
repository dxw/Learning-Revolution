Feature: Calendar
  In order to view the events
  As a user
  I should be view and filter events relevant to me
  
  Scenario: Viewing an unfiltered calendar
    Given a valid event called "Octoberfest"
    When I go to the calendar for October 2009
    Then I should see image "How to use this site"
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
    And a valid event called "Virtual Event"
    And the event "Virtual Event" starts on "12th October 2009 12:00"
    And the event "Virtual Event" has no location
    And a valid event called "Secret Event"
    And the event "Secret Event" is not published yet
    And the event "Secret Event" starts on "12th October 2009 12:00"
    And the event "Secret Event" is located at lat "51.584911" and lng "0.02591"
    When I go to the calendar for October 2009
    And I fill in "Postcode" with "E11 1PB GB"
    And I press "Search For Events"
    Then I should see "Octoberfest" in the calendar on day "12"
    And I should see "Virtual Event" in the calendar on day "12"
    And I should not see "Spanish Guitar"
    And I should not see "Secret Event"
    And the page is valid XHTML
    
  Scenario: Browsing back to the calendar
    Given a valid event called "Event 1"
    And the event "Event 1" starts on "1st October 2009 12:00"
    When I go to the calendar for October 2009
    And I press "Search For Events"
    Then I should see "Event 1"
    When I follow "Event 1"
    Then I should see "Listings for 1st October 2009"
    When I follow "« Back to search results"
    Then I should be on the calendar for October 2009
    And I should see "Event 1"
    And I should not see image "How to use this site"
    When I follow "Event 1"
    Then I should see "Listings for 1st October 2009"
    When I follow "Events"
    Then I should be on the calendar for October 2009
    And I should see "Event 1"
    And I should not see image "How to use this site"
    
  Scenario: Viewing the results on a map
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And the event "Octoberfest" is located at lat "51.584911" and lng "0.02591"
    When I go to the calendar for October 2009
    And I press "Search For Events"
    Then I should be on the calendar for October 2009
    When I follow "Map"
    Then I should see the map
    
