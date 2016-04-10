@calendar @javascript
Feature: Color events by category
  
  As an admin
  So that users can easily find Nature in the City Events they are interested in
  I want to color calendar events by their category
  
Background:
  Given the following events with category exist:
  | name            | start       | end         | st_number | st_name   | city  | description     | status    | contact_email | family_friendly | free  | category |
  | Market Street   | Mar-21-2017 | Mar-21-2017 | 1210      | street rd | SF    | A past hike     | approved  | joe@cnn.com   | true            | true  | learn    |
  | Nerds on Safari | Apr-15-2017 | Apr-15-2017 | 1210      | street rd | SF    | A Nerd Safari   | approved  | joe@cnn.com   | true            | false | hike     |
  | Event3          | Apr-10-2017 | Apr-10-2017 | 1210      | street rd | SF    | An event        | approved  | joe@cnn.com   | true            | false | plant    |
  | Event4          | Apr-11-2017 | Apr-11-2017 | 1210      | street rd | SF    | An event        | approved  | joe@cnn.com   | true            | false | volunteer|
  | Event5          | Apr-12-2017 | Apr-12-2017 | 1210      | street rd | SF    | An event        | approved  | joe@cnn.com   | true            | false | hike     |
  And I am on the calendar page
  
Scenario: Color by family_friendly
  And the month is March 2017
  Then the event "Market Street" should be colored "yellow"
  Given the month is April 2017
  Then the event "Nerds on Safari" should be colored "blue"
  And the event "Event3" should be colored "green"
  And the event "Event4" should be colored "orange"
  And the event "Event5" should be colored "blue"
 