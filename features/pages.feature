Feature: Pages

   Scenario: Viewing the frequently asked questions
      Given the default "Frequently Asked Questions" page
      When I go to the frequently asked questions page
      Then I should see "Frequently Asked Questions"
      And the page is valid XHTML

   Scenario: Viewing the about page
      Given the default "About" page
      When I go to the about page
      Then I should see "About"
      And the page is valid XHTML

   Scenario: Viewing the privacy policy
      Given the default "Privacy Policy" page
      When I go to the privacy policy
      Then I should see "Privacy Policy"
      And the page is valid XHTML

   Scenario: Viewing the terms and conditions
      Given the default "Terms and Conditions" page
      When I go to the terms and conditions page
      Then I should see "Terms and Conditions"
      And the page is valid XHTML

   Scenario: Viewing the copyright page
      Given the default "Copyright" page
      When I go to the copyright page
      Then I should see "Copyright"
      And the page is valid XHTML

   Scenario: Viewing the the promote your event page
      Given the default "Promote Your Event" page
      When I go to the the promote your event page
      Then I should see "Promote Your Event"
      And the page is valid XHTML

   Scenario: Viewing the the news page
      When I go to the the news page
      Then I should see "News"
