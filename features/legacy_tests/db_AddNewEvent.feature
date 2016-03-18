Feature: Add New Calendar Events straight to Database and Meetup
  
    Existing events should be in both the database and on meetup
    If I then create a new event and add it to the calendar
    It should update the current database as well as Meetup

  Background: Events have already been added to the database

    Given the following events exist:
      | name                                | organization       | description                               | venue_name                 | st_number | st_name    |city      | zip   | start                | end                  | how_to_find_us     | meetup_id | status   |
      | Market Street Prototyping Festival  | Nature in the City | A walk through the city                   | The Old Town Hall          | 145       | Jackson st | Glendale | 90210 | April 09 2016 11:00  | March 19 2016, 20:30 | First door on left | 122121212 | approved |
      | Nerds on Safari: Market Street      | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45        | Seneca st  | Phoenix  | 91210 | April 11 2016 00:00  | April 21 2016, 8:30  | Second door on left| 656555555 | approved |

  Scenario: Verify that they are in the database
    Given I know event "name": "Market Street Prototyping Festival"
    Then I should have "description": "A walk throught the city"
    And I should have "organization": "Nature in the City"
    Given I know event "organization": "Green Carrots"
    Then I should have "name": "Nerds on Safari: Market Street"
    And I should have "st_number": "45"
    
  Scenario: Verify that they are on Meetup
    Given I know event "name": "Market Street Prototyping Festival"
    Then the "Market Street Prototyping Festival" event should exist on "both" platforms
    Given I know event "name": "Nerds on Safari: Market Street"
    Then the "Nerds on Safari: Market Street" event should exits on "both" platforms
    
  Scenario: Add new events
    When I add new events:
      | name             | organization       | description                               | venue_name                 | st_number | st_name    |city      | zip   | start                   | end                     | how_to_find_us     | meetup_id | status   |
      | Market Festival  | Nature in the City | A local farmers market!                   | 5th Street Market          | 5         | 5th st     | SF       | 80598 | March 19 2016 12:00     | March 20 2016, 20:30    | Street Party       | 241513355 | approved |
      | Street Safari    | Blue Rice          | Come meet all the animals!                | Union Square               | 95        | 95th st    | SF       | 91078 | February 11 2016 00:00  | February 19 2016, 8:30  | Street Party       | 165545658 | approved |


  Scenario: Verify new events are in the database
    Given I know event "name": "Market Festival"
    Then I should have "description": "A local farmers market!"
    And I should have "organization": "Nature in the City"
    Given I know event "organization": "Blue Rice"
    Then I should have "name": "Street Safari"
    And I should have "st_number": "95"
    
  Scenario: Verify new events are on Meetup
    Given I know event "name": "Market Festival"
    Then the event should exist on "both" platforms
    Given I know event "name": "Nerds on Safari: Market Street"
    Then the event should exist on "both" platforms
    