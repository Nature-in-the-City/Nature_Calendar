@javascript
Feature: Populate calendar with events

  As an admin
  So that I can advertise my events to website vistors
  I want to be able to populate my calendar with events

Background: Events have already been added to the database

  Given the following events exist:
    | name                                | organization       | description                               | venue_name                 | st_number | st_name    |city     | zip   | start                | end                  | how_to_find_us     | meetup_id |
    | Market Street Prototyping Festival  | Nature in the City | A walk through the city                   | The Old Town Hall          | 145       | Jackson st | Glendale | 90210 | April 09 2015 11:00  | March 19 2015, 20:30 | First door on left | 122121212 |
    | Nerds on Safari: Market Street      | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45        | Seneca st  | Phoenix  | 91210 | April 11 2015 00:00  | April 21 2015, 8:30  | Second door on left| 656555555 |

Scenario: see events on calendar page
  Given I am on the calendar page
  Then I should see the event "Market Street Prototyping Festival" on "April 09, 2015"
  And I should see the event "Nerds on Safari: Market Street" on "April 11, 2015"
