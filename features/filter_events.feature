Feature: Filter Events by family friendly
  
  As a parent
  So that I can find Nature in the City Events appropriate for my children
  I want to filter the event calendar by family friendly
  
Background:
  Given I am on the Calendar page
  
Scenario: Filter by family friendly
  Given I check "Filter by Family Friendly"
  And I view calendar month "February"
  Then I should see "Event1"
  And I view calendar month "March"
  Then I should see "Event4"
  And I should not see "Event2"
  And I should not see "Event3"
  
Scenario: No family friendly events available
  Given I check "Filter by Family Friendly"
  And I view calendar month "
 