@calendar @javascript
Feature: Filter Events by family friendly
  
  As a parent
  So that I can find Nature in the City Events appropriate for my children
  I want to filter the event calendar by family friendly
  
Background:
  Given the following events exist:
  | name            | start       | end         | st_number | st_name   | city  | description     | status    | contact_email | family_friendly | free  |
  | Market Street   | Mar-21-2016 | Mar-21-2016 | 1210      | street rd | SF    | A past hike     | approved  | joe@cnn.com   | true            | true  |
  | Nerds on Safari | Apr-15-2016 | Apr-15-2016 | 1210      | street rd | SF    | A Nerd Safari   | approved  | joe@cnn.com   | true            | false |
  And I am on the calendar page
  And I select "No Filter" from "event_filter"
  
Scenario: Filter by family friendly
  And I select "Family Friendly" from "event_filter"
  And I press the "Pending" tab
  And the month is March 2016
  Then I should see "Market Street"
  Given the month is April 2016
  Then I should see "Nerds on Safari"
  
Scenario: Filter by free
  Given I select "Free" from "event_filter"
  And I press the "Pending" tab
  And the month is March 2016
  Then I should see "Market Street"
  Given the month is April 2016
  Then I should not see "Nerds on Safari"
 