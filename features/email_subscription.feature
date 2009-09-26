Feature: Email Subscription
  In order to stay updated about new events relevant to me
  As a user
  I should be able to subscribe to email updates about events relevant to me
  
  @wip
  Scenario: Requesting an email of a filtered selection of events
    Given I am on the calendar for October 2009 filtered by the theme "Food and Cookery"
    When I follow "Send me these events as email"
    And I fill in "Email address" with "example@example.com"
    And I press "Send"
    Then I should be on the calendar for October 2009 filtered by the theme "Food and Cookery"
    And I should see "sent to example@example.com"
    And I should receive an events listing email
  
  @wip
  Scenario: Subscribing to event updates by email
    Given I have requested an email of events filtered by the theme "Food and Cookery"
    And I have received the events listing email
    When I open the email
    And I follow "subscribe to updates" in the email
    And I press "Yes"
    Then I should see "now subscribed"
  
  @wip
  Scenario: Receiving an event update when new events have been added
    Given I have subscribed to updates about events filtered by the theme "Sport and Physical Activity"
    When someone adds an event called "Goose Juggling"
    And an administrator approves the event "Goose Juggling"
    And the daily email updates are sent
    Then I should receive an event update email
    And I should see "Goose Juggling" within the email body
  
  @wip
  Scenario: Unsubscribing from event updates by email
    Given I have subscribed to updates about events filtered by the theme "Sport and Physical Activity"
    And I have received an event update email
    When I open the email
    And I follow "Unsubscribe" in the email
    And I press "Unsubscribe"
    Then I should see "unsubscribed"
