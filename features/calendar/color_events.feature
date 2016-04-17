@calendar @javascript
Feature: Color events by category
  
  As a user
  So that I can easily find Nature in the City Events I am interested in
  I want to calendar events colored by their category
  
Background:
  Given the following events exist:
  | name            | start        | end         | st_number | st_name   | city  | description     | status    | contact_email | family_friendly | free  | category |
  | Market Street   | July-21-2016 | Mar-21-2017 | 1210      | street rd | SF    | A past hike     | approved  | joe@cnn.com   | true            | true  | learn    |
  | Nerds on Safari | July-15-2016 | Apr-15-2017 | 1210      | street rd | SF    | A Nerd Safari   | approved  | joe@cnn.com   | true            | false | hike     |
  | Event4          | July-11-2016 | Apr-11-2017 | 1210      | street rd | SF    | An event        | approved  | joe@cnn.com   | true            | false | volunteer|
  | Event5          | July-12-2016 | Apr-12-2017 | 1210      | street rd | SF    | An event        | approved  | joe@cnn.com   | true            | false | play     |
  And I am on the calendar page
  
Scenario: Color by family_friendly
  And the month is July 2016
  Then I should see "Market Street"
  And the event "Market Street" should be colored "yellow"
  Then the event "Nerds on Safari" should be colored "blue"
  And the event "Event4" should be colored "green"
  And the event "Event5" should be colored "pink"
 