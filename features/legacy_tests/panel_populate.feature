@javascript
Feature: populate the event panel with event details
  As a user
  to learn the details of events I might want to go to
  I want to see event details in the panel

Background: events have already been added to the database
  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | st_number | st_name    | city     | zip   | start                | end                  | how_to_find_us     | meetup_id |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145       | Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left | 56565656  |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45        | Seneca st  | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left| 11111111  |

  And I am on the calendar page

Scenario: see the event title
  When the month is April 2015
  And I click on "Green Bean Mixer" in the calendar
  Then the panel should display "Green Bean Mixer" in its "title" field

Scenario: see the event time
  When the month is March 2015
  And I click on "Nature Walk" in the calendar
  Then the panel should display "Mar 19, 2015 at 4:30pm to 8:30pm" in its "time" field
  When the month is April 2015
  And I click on "Green Bean Mixer" in the calendar
  Then the panel should display "Apr 20, 2015 at 8:30am to Apr 21, 2015 at 8:30am" in its "time" field

Scenario: see the event location
  When the month is April 2015
  And I click on "Green Bean Mixer" in the calendar
  Then the panel should display "45 Seneca st" in its "location" field

Scenario: see event description
  When the month is April 2015
  And I click on "Green Bean Mixer" in the calendar
  Then the panel should display the description for "Green Bean Mixer"
  When the month is March 2015
  And when I click on "Nature Walk" in the calendar
  Then the panel should display the description for "Nature Walk"
