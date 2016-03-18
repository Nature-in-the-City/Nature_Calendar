@javascript
Feature: See who RSVPed for event

  As a user
  So that I can predict who's attending the event
  I want to be able to view who has RSVPed to the event

Background:
  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | st_number | st_name    | city     | zip   | start                | end                  | how_to_find_us     |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145       | Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45        | Seneca st  | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left|

  And the following guests exist:
  | first_name | last_name | phone          | email            | address            | is_anon |
  | John       | Smith     | (816) 567-8521 | jsmith@site.com  | 12 Washington Blvd | false   |
  | Jacob      | Harrison  | (932) 123-4567 | jharry@gmail.com | 10 Whatever St     | true    |
  | Adam       | Johnson   | (123) 987-4321 | ajohns@yahoo.com | 38 Smithsonian Ave | true    |
  | Mary       | Jackson   | (789) 425-8967 | mjacks@msn.com   | 98 White Horse Ave | true    |
  | Max        | Leroy     | (723) 123-8900 | maxler@aol.com   | 69 Feeling St      | false   |

  And the following registrations exist:
  | event_id | guest_id |
  | 1        | 1        |
  | 1        | 2        |
  | 1        | 3        |
  | 2        | 1        |
  | 2        | 2        |
  | 2        | 4        |
  | 2        | 5        |

Scenario: Guest sees all event attendees
  Given I am on the "Calendar" page
  And the month is March 2015
  When I click on "Nature Walk" in the calendar
  Then I should see attendees of "Nature Walk" listed alphabetically by first name
  But I should not see anonymous attendees of "Nature Walk"
