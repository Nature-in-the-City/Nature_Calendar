@javascript
Feature: Be able to create, edit, and delete events via a panel on the calendar page

  As an admin
  so that I can manage events all in one place
  I want to be able to create, edit, and delete events on the calendar page

Background: Events have already been added to the database

  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | st_number | st_name    | city     | zip   | start                | end                  | how_to_find_us     |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145       | Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45        | Seneca st  | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left |


  And I am logged in as the admin
  And I am on the calendar page

Scenario: show the new event panel
  When I click on the new event button
  Then I should see the "new form" in the panel

Scenario: Show the event editing panel
  Given the month is March 2015
  When I click on "Nature Walk" in the calendar
  And I click on the edit event button
  Then I should see the "edit form" in the panel
  When I change the start time to "April 16 12:00 am"
  And save the event
  Then I should see "Nature Walk" on "April 16" in the calendar

Scenario: Delete an event
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  And I click on the delete event button
  Then "Green Bean Mixer" should not be in the calendar
