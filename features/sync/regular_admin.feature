@sync @javascript
Feature:
  As a trusted friend of nature city
  To add calendars and events for our orgnization
  I can be a regular admin
  
  Background:
    Given I am a logged in as a Regular Admin
    And I see the Admin panel
    
  Scenario: Regular admin can't add or edit users
    Then I should not see "Create New User"
    And I should not see "Edit Existing User"
    And I see the following status tabs: "Upcoming", "Pending", "Rejected", "Past"
    
  Scenario: Regular admin can't approve events
    Given I press the "Pending" tab
    Then I should not see "accept"
    And I should not see "reject"

  Scenario: Regular admin can't delete events
    Given I press the "Rejected" tab
    Then I should not see "delete"