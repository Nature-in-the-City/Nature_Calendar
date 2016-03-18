@javascript
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
    And I fill in the required event form details
    And I press "suggest"
    Then I should see "Your Event was successfully submitted for approval!"
  
  Scenario: Submit Event failure
    When I press "suggest"
    Then I should see "You must fill out all required fields (marked with a *)"