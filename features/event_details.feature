Feature: Event show page
  
  Scenario: Viewing a calendar filtered by location
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