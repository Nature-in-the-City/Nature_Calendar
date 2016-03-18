Feature: Filter Events by family friendly
  
  As a parent
  So that I can find Nature in the City Events appropriate for my children
  I want to filter the event calendar by family friendly
  
Given the following events exist:
  | Name                    | Location | event_date     | event_type      |
  | Event1                  | SF       | 25-Feb-2016    | family_friendly |
  | Event2                  | SF       | 26-March-2016  |                 |
  | Event3                  | SF       | 21-March-2016  |                 |
  | Event4                  | SF       | 10-March-2016  | family_friendly |

  And  I am on the Calendar page
  
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
 