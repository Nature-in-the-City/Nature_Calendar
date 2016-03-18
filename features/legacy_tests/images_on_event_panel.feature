@javascript
Feature: See images for a particular event

  As a user
  so that I have a sense of what will happen at the event
  I want to see pictures relate to the event on its details panel

Background:
  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | st_number      |   st_name     | city     | zip   | start                | end                  | how_to_find_us     | meetup_id |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145     |   Jackson st     | Glendale | 90210 | March 19 2015, 16:30 | May 19 2015, 20:30 | First door on left | 544545444 |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45      |     Seneca st   | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left| 454444444 |

  And I am logged in as the admin
  And I am on the calendar page
  When the month is March 2015
  Then I click on "Nature Walk" in the calendar

  Scenario: User should see all pictures related to the event
  When I upload an image for "Nature Walk"
  And I click on "Nature Walk" in the calendar
  Then I should see the picture "nature1.jpg" for "Nature Walk"
