Feature: Venue admin
  In order to keep the venue data clean
  As an admin
  I should be able to be able to add, edit and delete venues

  Background:
    Given I am logged in

  Scenario: Adding a valid venue
    When I go to the venue admin index page
    And I follow "New venue"
    And I fill in "Name" with "Venue name"
    And I fill in "Address 1" with "Address 1 name"
    And I fill in "Address 2" with "Address 2 name"
    And I fill in "Address 3" with "Address 3 name"
    And I fill in "City" with "City name"
    And I fill in "County" with "County name"
    And I fill in "Postcode" with "Postcode name"
    And I press "Create"
    Then I should see "Venue created successfully"
    And I should see "Venue name"
    And I am on the venue admin index page

  Scenario: Submitting an empty form
    When I go to the venue admin index page
    And I follow "New venue"
    And I press "Create"
    Then I should see "errors prohibited this venue from being saved"
    And I should see "Name can't be blank"
    And I should see "Postcode can't be blank"
    And I am on the venue admin index page

  Scenario: Editing a valid venue
    Given a valid venue called "Venue 1"
    When I go to the venue admin index page
    And I follow "Venue 1"
    And I fill in "Name" with "New Venue name"
    And I fill in "Address 1" with "123 Anywhere St"
    And I press "Save"
    Then I should see "Venue saved successfully"
    And I should see "New Venue name"
    And I am on the venue admin index page

  Scenario: Removing the new venue in a duplicate
    Given a valid venue called "venue 1"
    And a valid venue called "venue 2"
    When I go to the venue duplicates page
    Then I should see "venue 1"
    And I should see "venue 2"
    When I press "Remove new venue"
    Then I should see "venue 2 was deleted"
    And I should not see "venue 1"

  Scenario: Removing the original venue in a duplicate
    Given a valid venue called "venue 1"
    And a valid venue called "venue 2"
    When I go to the venue duplicates page
    Then I should see "venue 1"
    And I should see "venue 2"
    When I press "Remove original venue"
    Then I should see "venue 1 was deleted"
    And I should not see "venue 2"

  Scenario: Searching for a venue by title
    Given a valid venue called "apples"
    And the venue "apples" has the post code "BD7 1QA"
    And a valid venue called "bananas"
    And the venue "bananas" has the post code "S11 8RE"
    And I go to the venue admin index page
    And I fill in "Venue" with "bananas"
    And I press "Search For Venues"
    Then I should see "bananas"
    And I should see "S11 8RE"
    And I should not see "apples"

  Scenario: Searching for a venue by post code
    Given a valid venue called "apples"
    And the venue "apples" has the post code "BD7 1QA"
    And a valid venue called "bananas"
    And the venue "bananas" has the post code "S11 8RE"
    And I go to the venue admin index page
    And I fill in "Venue" with "BD7 1QA"
    And I press "Search For Venues"
    Then I should see "apples"
    And I should see "BD7 1QA"
    And I should not see "bananas"
