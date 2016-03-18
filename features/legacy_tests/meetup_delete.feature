@javascript
@meetup_delete
Feature: Enforce event lists consistency by deleting events locally and remotely as required

  As an admin of the website
  To guarantee I don't have to maintain two sets of identical events
  I want to have automatic deletions between the Calendar events and the Meetup events

  Background: The Calendar and Meetup are currently synched

    Given I am logged in as the admin
    And I am an authorized organizer of the group
    And the following event exists on Meetup and on the Calendar
      |    name      |    organization    |   event_id   |
      | Nature Walk  | Nature in the city | 221850455    |
      | Nerds Safari | Nature in the city | 220706208    |
    And the month is August 2015

  @calendar_successful_deletion
  Scenario: deletion initiated on Calendar
    Given I click on "Nature Walk" in the calendar
    And I click on the "Delete" button
    And the "Nature Walk" event should exist on "neither" platforms

  @calendar_failed_deletion
  Scenario: failed deletion initiated on Calendar
    Given I click on "Nature Walk" in the calendar
    And I click on the "Delete" button
    And the "Nature Walk" event should exist on "both" platforms

  @meetup_successful_deletion
  Scenario: deletion initiated on Meetup
    Given the event "Nature Walk" is deleted on Meetup
    Then the "Nature Walk" event should exist on "neither" platforms
