@meetup_pull_3rd_by_id
Feature: pull 3rd-party events created on Meetup by event ID and display them on the calendar

  As an admin
  So that I can support other 3rd-party organizations with similar interests to my own
  I want to be able to collect their Meetup events and display them on my calendar

  Background: 3rd-party Events have already been created on Meetup

    Given I am logged in as the admin
    And the following events exist on Meetup:
      |                 name       |    organization          |   event_id   |
      | Walk the Moon              | Live Music San Francisco | 220680184    |

    And I am on the calendar page
    And I click on the "+ 3rd Party" button
    Then I should be on the "third_party" page
    And I should see the following fields: "ID"
    And I should see the "Search, Add Events" buttons

  @search_event_by_id
  Scenario: search an event
    Given I fill in the "ID" field with "220680184"
    And I click on the "Search" button
    Then I should be on the "third_party" page
    And I should see the list "#matched_events" containing: "Walk the Moon"

  @successful_pull_third_event
  Scenario: successfully pull an event
    Given I searched an event by id: "220680184"
    And I check "Select" for "event220680184"
    And I click on the "Add Events" button
    Then I should be on the "Calendar" page
    And the Meetup event "Walk the Moon" should exist
    #And I should see the message "Successfully added: Walk the Moon"

  @failed_pull_third_event
  Scenario: fail to pull an event
    Given I searched an event by id: "220680184"
    And I check "Select" for "event220680184"
    And I attempt to click on the "Add Events" button
    #Then I should be on the "Calendar" page
    And the Meetup event "Walk the Moon" should not exist
    #And I should see the message "Could not add event. Please retry."

  @search_event_by_id
  Scenario: attempt to pull no selected events
    Given I searched an event by id: "220680184"
    And I click on the "Add Events" button
    Then I should be on the "third_party" page
    And I should see the message "You must select at least one event. Please retry."

  @repeated_unchanged_pull_third_event
  Scenario: re-pull an unchanged event
    Given I already pulled the event id: "220680184"
    And I searched an event by id: "220680184"
    And I check "Select" for "event220680184"
    And I click on the "Add Events" button
    Then I should be on the "Calendar" page
    And the Meetup event "Walk the Moon" should exist
    #And I should see the message "These events are already in the Calendar, and are up to date."

  @repeated_changed_pull_third_event
  Scenario: successfully pull an updated event
    Given I already pulled the event id: "220680184"
    And the event with id: 220680184 is renamed on Meetup to Walk the Planet
    And I searched an event by id: "220680184"
    And I check "Select" for "event220680184"
    And I click on the "Add Events" button
    Then I should be on the "Calendar" page
    And the Meetup event "Walk the Planet" should exist
    #And I should see the message "Successfully added: Walk the Planet"








