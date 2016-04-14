@calendar @javascript
Feature: Guests can suggest Events for approval by an admin
  
  As a guest of Nature in the City
  So that I can bring the Nature in the City community to my Event
  I want to submit my Event to the calendar for approval by an admin 
  
  Background:
    Given I am not logged in as the admin
    And I am on the calendar page
    And I press "Suggest Event"
    Then I should see the "Suggest Your Event" in the panel
  
  Scenario: Submit an Event
    When I fill in the required suggest event form details for event "Garden Party" on "3/22/2017" and submit
    Then I log in as admin
    And I press the "Pending" tab
    Then I should see "Garden Party"
  
  Scenario: Submit Event failure
    When I press "submit_suggest_event"
    Then I should not see "Successfully added 'Garden Party'"