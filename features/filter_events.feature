Feature: Filter Events by family friendly
  
  As a parent
  So that I can find Nature in the City Events appropriate for my children
  I want to filter the event calendar by family friendly
  
Background:
  Given I am on the Calendar page
  And the month is March 2016
  
Scenario: Filter by family friendly
  Given I check the filter for "Family Friendly"
  Then I should see "Market Street Prototyping Festival"
  Given the month is May 2016
  And I should not see "Bay to Breakers"
  
Scenario: No family friendly events available
  Given I check "Filter by Family Friendly"
  And I view calendar month "
 