Feature: Admin Login
  As a user
  I should not be able to access admin pages
  So that all the data is not damaged
  So that people can view events
  
  Scenario: Trying to access events admin
    When I go to the new event admin page
    Then I should be denied access
    When I go to event admin index page
    Then I should be denied access
    When I go to the event duplicates page
    Then I should be denied access
    When I go to the events moderation page
    Then I should be denied access
  
  Scenario: Trying to access venues admin
    When I go to the new venue admin page
    Then I should be denied access
    When I go to venue admin index page
    Then I should be denied access
    When I go to the venue duplicates page
    Then I should be denied access
    