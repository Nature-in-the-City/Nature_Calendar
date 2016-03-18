@javascript
@meetup_edit
Feature: Enforce event lists consistency by updating events locally and remotely as required

  As an admin of the website
  To guarantee I don't have to maintain two sets of identical events
  I want to have automatic updates between the Calendar events and the Meetup events

  Background: The Calendar and Meetup are currently synched

    Given I am logged in as the admin
    And I am an authorized organizer of the group
    And the following event exists on Meetup and on the Calendar
      |    name      |    organization    |   event_id   |
      | Nature Walk  | Nature in the city | 221850455    |
    And the month is August 2015

  @calendar_successful_edit
  Scenario: update initiated on Calendar
    Given I click on "Nature Walk" in the calendar
    And I click on the "Edit" button
    And I fill in the "Name" field with "Festival"
    And I click on the "Save Event" button
    Then the event "Nature Walk" should be renamed to "Festival" on "both" platforms
    And I should see the message "Festival successfully updated!"

  @calendar_failed_edit
  Scenario: failed update initiated on Calendar
    Given I click on "Nature Walk" in the calendar
    And I click on the "Edit" button
    And I fill in the "Name" field with "Festival"
    And I click on the "Save Event" button
    Then the event "Nature Walk" should be renamed to "Festival" on "neither" platforms
    And I should see the javascript message "Could not update 'Nature Walk'"

  @meetup_successful_edit
  Scenario: update initiated on Meetup
    Given the event "Nature Walk" is renamed on Meetup to "Festival"
    And I synchronize the calendar with meetup
    Then the event "Nature Walk" should be renamed to "Festival" on "both" platforms
