@javascript
@meetup_pull
Feature: automatically pull existing events from Meetup onto the calendar

  As a user of the website
  So that I can view all of Nature in the City's events in one place
  I want to be able to see website events and Meetup events on the same calendar


  Background: The calendar has never pulled Meetup events before:

    Given the following events exist on Meetup:
      |                 name                    |    organization    |   event_id   |
      | Market Street Prototyping Festival      | Nature in the city | 219648262    |
      | Nerds on Safari: Market Street          | Nature in the city | 220706208    |
      | Volunteer at the Adah Bakalinsky Steps! | Nature in the city | 214161012    |

  @successful_pull_meetup
  Scenario: perform a successful pull from Meetup
    Given I synchronize the calendar with meetup
    Then the Meetup events "Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps!" should exist
    #And I should see the message "Successfully pulled events: Market Street Prototyping Festival, Nerds on Safari: Market Street, Volunteer at the Adah Bakalinsky Steps! from Meetup"

  @failed_pull_meetup
  Scenario: failed pull from Meetup
    Given I attempt to synchronize the calendar with meetup
    Then the Meetup events "Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps!" should not exist
    #And I should see the message "Could not pull events from Meetup"

  @repeated_changed_pull_meetup
  Scenario: perform a successful pull of updated events from Meetup
    Given I already pulled from Meetup
    And the meetup event "Market Street Prototyping Festival" is updated to the name "Prototyping Festival"
    And I synchronize the calendar with meetup
    Then the Meetup events "Prototyping Festival" should exist
    And the Meetup events "Market Street Prototyping Festival" should not exist
    #And I should see the message "Successfully pulled events: Prototyping Festival from Meetup"

  @repeated_unchanged_pull_meetup
  Scenario: perform a successful pull of unchanged events from Meetup
    Given I already pulled from Meetup
    And I synchronize the calendar with meetup
    Then the Meetup events "Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps!" should exist
    #And I should see the message "The Calendar and Meetup are synched"