Feature: Viewing events
  As a user
  I should be view the details page of each event
  In order to see important info about each event
  So that I can attend

  Scenario: Reporting an offensive or incorrect event
    Given a valid event called "Event 1"
    And I go to the event page for "Event 1"
    Then I should see "Event 1"
    And I should see "Offensive? Incorrect?"
    And the page is valid XHTML

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
    When I follow "« Earlier"
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
    When I follow "Later »"
    Then I should see "Event 2"
    Then I should see "2 Oct"
    And the page is valid XHTML

  Scenario: Browsing backwards through the event list on the 1st of October
    Given a valid event called "Event 1"
    And the event "Event 1" starts on "1st October 2009 12:00"
    When I go to the event page for "Event 1"
    Then I should not see "« Earlier"
    And the page is valid XHTML

  Scenario: Browsing forwards through the event list on the 31st of October
    Given a valid event called "Event 1"
    And the event "Event 1" starts on "31st October 2009 12:00"
    When I go to the event page for "Event 1"
    Then I should not see "Later »"
    And the page is valid XHTML

  Scenario: Atom feed
    Given a valid event called "Event 1"
    And the event "Event 1" starts on "31st October 2009 12:00"
    When I go to the calendar for October 2009
    And I press "Search For Events"
    And I follow "Add to my feed reader."
    Then I should see "Event 1"
    And the page is valid Atom

  Scenario: iCalendar "feed"
    Given a valid event called "Event 1"
    And the event "Event 1" starts on "31st October 2009 12:00"
    Given a valid event called "Event 2"
    And the event "Event 2" starts on "1st October 2009 13:00"
    When I go to the calendar for October 2009
    And I press "Search For Events"
    And I follow "Add these events to iCal."
    Then I should see "Event 1"
    And the page is valid iCalendar
    And the calendar holds 2 events

  Scenario: iCalendar single event
    Given a valid event called "Event 1"
    And the event "Event 1" starts on "31st October 2009 12:00"
    When I go to the event page for "Event 1"
    When I follow "Add to iCal"
    Then I should see "Event 1"
    And the page is valid iCalendar
    And the calendar holds 1 event

  Scenario: Redirecting to the next month with events
    pending

  Scenario: Showing previous/next month labels
    pending

  Scenario: Showing view n events in %B
    pending
