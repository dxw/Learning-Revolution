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
    And the page is valid XHTML

  Scenario: Viewing an event without a venue
    Given a valid event called "Festival of Ideas"
    And I go to the event page for "Festival of Ideas"
    Then I should see "Festival of Ideas"
    And the page is valid XHTML

  Scenario: Viewing an event with a hidden event on the same day
    Given a valid event called "Octoberfest"
    And the event "Octoberfest" starts on "12th October 2009 12:00"
    And a valid event called "Spanish Guitar"
    And the event "Spanish Guitar" starts on "13th October 2009 12:00"
    And a valid event called "Secret Event"
    And the event "Secret Event" is not published yet
    And the event "Secret Event" starts on "12th October 2009 12:00"
    When I go to the event page for "Octoberfest"
    Then I should see "Octoberfest"
    And I should not see "Spanish Guitar"
    And I should not see "Secret Event"
    And the page is valid XHTML
    
  Scenario: Browsing backwards through the event list
    Given a valid event called "Event 1" 
    And a valid event called "Event 2"
    And the event "Event 1" starts on "1st October 2009 12:00"
    And the event "Event 2" starts on "2nd October 2009 12:00"
    When I go to the event page for "Event 2"
    Then I should see "Event 2"
    And I should see "2 Oct"
    And the page is valid XHTML
    When I follow "« Prev day"
    Then I should see "Event 1"
    And I should see "1 Oct"
    And the page is valid XHTML
    
  Scenario: Browsing forwards through the event list
    Given a valid event called "Event 1" 
    And a valid event called "Event 2"
    And the event "Event 1" starts on "1st October 2009 12:00"
    And the event "Event 2" starts on "2nd October 2009 12:00"
    When I go to the event page for "Event 1"
    Then I should see "Event 1"
    Then I should see "1 Oct"
    And the page is valid XHTML
    When I follow "Next day »"
    Then I should see "Event 2"
    Then I should see "2 Oct"
    And the page is valid XHTML
    
