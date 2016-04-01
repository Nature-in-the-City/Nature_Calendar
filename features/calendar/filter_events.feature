@javascript
Feature: Filter Events by family friendly
  
  As a parent
  So that I can find Nature in the City Events appropriate for my children
  I want to filter the event calendar by family friendly
  
Background:
  Given I am on the calendar page
  And the month is March 2016
  
Scenario: Filter by family friendly
  Given I select "Family Friendly" from "event_filter"
  Then I should see "Market Street"
  Given the month is April 2016
  Then I should see "Nerds on Safari"
  
Scenario: Filter by free
  Given I select "Free" from "event_filter"
  Then I should see "Market Street"
  Given the month is April 2016
  Then I should not see "Nerds on Safari"
 