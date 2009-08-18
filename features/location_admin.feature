Feature: Location admin
  In order to keep the location data clean
  As an admin
  I should be able to be able to add, edit and delete locations
  
  Scenario: Adding a valid location
    When I go to the location admin index page
    And I follow "New location"
    And I fill in "Name" with "Location name"
    And I fill in "Address 1" with "Address 1 name"
    And I fill in "Address 2" with "Address 2 name"
    And I fill in "Address 3" with "Address 3 name"
    And I fill in "City" with "City name"
    And I fill in "County" with "County name"
    And I fill in "Postcode" with "Postcode name"
    And I press "Create"
    Then I should see "Location created successfully"
    And I should see "Location name"
    And I am on the location admin index page
    
  Scenario: Submitting an empty form
    When I go to the location admin index page
    And I follow "New location"
    And I press "Create"
    Then I should see "errors prohibited this location from being saved"
    And I should see "Name can't be blank"
    And I should see "Postcode can't be blank"
    And I am on the location admin index page
  
  Scenario: Editing a valid location
    Given a valid location called "Location 1"
    When I go to the location admin index page
    And I follow "Location 1"
    And I fill in "Name" with "New Location name"
    And I press "Save"
    Then I should see "Location saved successfully"
    And I should see "New Location name"
    And I am on the location admin index page
  