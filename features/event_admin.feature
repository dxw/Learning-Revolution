Feature: Event admin
  In order to keep the event data clean
  As an admin
  I should be able to be able to add, edit and delete events

  Background:
    Given I am logged in

  Scenario: Adding a valid event
    Given a valid venue called "London"
    When I go to the event admin index page
    And I follow "New event"
    And I fill in "Event name" with "New event title"
    And I fill in "Description" with "event description"
    And I fill in "Category" with "event theme"
    And I fill in "Event Type" with "event type"
    And I select "11" from "starthour"
    And I select "20" from "startminute"
    And I select "23rd" from "startday"
    And I select "November" from "startmonth"
    And I select "2010" from "startyear"
    And I select "12" from "endhour"
    And I select "20" from "endminute"
    And I select "23rd" from "endday"
    And I select "November" from "endmonth"
    And I select "2010" from "endyear"
    And I fill in "Cost" with "£1.50"
    And I fill in "Min Age" with "13"
    And I select "London" from "Venue"
    And I fill in "Organisation" with "BIS"
    And I fill in "Contact Name" with "event organiser"
    And I fill in "Contact Phone Number" with "020 8547 3847"
    And I fill in "Contact Email Address" with "contact@test.com"
    And I check "Published"
    And I fill in "Picture" with "http://www.google.co.uk/intl/en_uk/images/logo.gif"
    And I check "Featured"
    And I select "Tom City Council" from "Provider"
    And I press "Add this event to the listings"
    Then I should see "Event created successfully"
    And I should see "Tuesday 23 Nov 2010"
    And the page is valid XHTML

  Scenario: Submitting an empty form
    When I go to the event admin index page
    And I follow "New event"
    And I press "Add this event to the listings"
    Then I should see "3 errors prohibited this event from being saved"
    And I should see "Event name can't be blank"
    And I should see "Contact name can't be blank"
    And I should see "Contact email address can't be blank"
    And I am on the event admin index page

  Scenario: Editing a valid event
    Given a valid event called "event 1"
    When I go to the event admin index page
    And I follow "event 1"
    And I fill in "Event name" with "New event title"
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

  Scenario: Editing an event mid moderation
    Given a valid event called "event 1"
    And a valid event called "event 2"
    When I go to the event duplicates page
    And I follow "Edit original event"
    And I press "Save"
    Then I should be on the event duplicates page

  Scenario: Moderating events with approval
    Given a valid event called "event 1"
    And the event "event 1" is not published yet
    And a valid event called "event 2"
    And the event "event 2" is not published yet
    When I go to the events moderation page
    Then I should see "event 1"
    When I press "Approve"
    Then I should see "event 1 has been published"
    And I should see "event 2"

  Scenario: Moderating events with deletion
    Given a valid event called "event 1"
    And the event "event 1" is not published yet
    And a valid event called "event 2"
    And the event "event 2" is not published yet
    When I go to the events moderation page
    Then I should see "event 1"
    When I press "Delete"
    Then I should see "event 1 has been deleted"
    And I should see "event 2"

  Scenario: Moderating events with skipping
    Given a valid event called "event 1"
    And the event "event 1" is not published yet
    And a valid event called "event 2"
    And the event "event 2" is not published yet
    When I go to the events moderation page
    Then I should see "event 1"
    When I follow "Skip"
    Then I should not see "event 1 has been deleted"
    And I should not see "event 1 has been published"
    And I should see "event 2"

  Scenario: Searching for an event by title
    Given a valid event called "apples"
    When I go to the event admin index page
    And I fill in "Event name" with "apples"
    And I press "Search For Events"
    Then I should see "apples"

  Scenario: Searching for an event by title, differing case
    Given a valid event called "apples"
    When I go to the event admin index page
    And I fill in "Event name" with "Apples"
    And I press "Search For Events"
    Then I should see "apples"

  Scenario: Searching for an event by description
    Given a valid event called "apples"
    And the event "apples" has the description "bananas"
    And I go to the event admin index page
    And I fill in "Event name" with "bananas"
    And I press "Search For Events"
    Then I should see "apples"
