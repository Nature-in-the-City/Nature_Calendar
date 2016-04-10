@legacy
Feature:
  As a user or admin
  to interact with the events
  I want to see an event panel beside the calendar

Background: events are loaded into database
  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | st_number | st_name    | city     | zip   | start                | end                  | how_to_find_us     | meetup_id |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145       | Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left | 5656565   |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45        | Seneca st  | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left| 1112222   |


  Scenario: see the panel
  Given I am on the calendar page
  Then I should see the default panel
