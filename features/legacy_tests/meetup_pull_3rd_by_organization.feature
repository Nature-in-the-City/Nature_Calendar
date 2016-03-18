@meetup_pull_3rd_by_organization
Feature: pull 3rd-party events created on Meetup by organization name and display them on the calendar

  As an admin
  So that I can support other 3rd-party organizations with similar interests to my own
  I want to be able to collect their Meetup events and display them on my calendar

  Background: No 3rd-party events have ever been pulled on the calendar before

    Given I am logged in as the admin
    And the following events exist on Meetup:
      |                          name                                   |    organization          |   group_urlname   |   event_id  |
      |                       Walk the Moon                             | Live Music San Francisco | LiveMusicSF       |  220680184  |
      | Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha!  | Live Music San Francisco | LiveMusicSF       |  220804867  |

    And I am on the calendar page
    And I click on the "+ 3rd Party" button
    Then I should be on the "third_party" page
    And I should see the following fields: "Group Name"
    And I should see the "Search, Add Events" buttons

  @search_events_by_group
  Scenario: search an event
    Given I fill in the "Group Name" field with "LiveMusicSF"
    And I click on the "Search" button
    Then I should be on the "third_party" page
    And I should see the list "#matched_events" containing: "'Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! ' 'Walk the Moon'"

  @successful_pull_third_events
  Scenario: successfully pull events
    Given I searched events by group_urlname: "LiveMusicSF"
    And I check "Select" for "event220680184, event220804867"
    And I click on the "Add Events" button
    Then I should be on the "Calendar" page
    And the Meetup events "'Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! ' 'Walk the Moon'" should exist
    #And I should see the message "Successfully added: Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! , Walk the Moon"

  @failed_pull_third_events
  Scenario: fail to pull events
    Given I searched events by group_urlname: "LiveMusicSF"
    And I check "Select" for "event220680184, event220804867"
    And I attempt to click on the "Add Events" button
    #Then I should be on the "Calendar" page
    And the Meetup events "'Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! ' 'Walk the Moon'" should not exist
    #And I should see the message "Could not add event. Please retry."

  @search_events_by_group
  Scenario: attempt to pull no selected events
    Given I searched events by group_urlname: "LiveMusicSF"
    And I try to click on the "Add Events" button
    Then I should be on the "third_party" page
    And I should see the message "You must select at least one event. Please retry."

  @repeated_unchanged_pull_third_events
  Scenario: re-pull unchanged events
    Given I already pulled by group_urlname: "220680184"
    And I searched events by group_urlname: "LiveMusicSF"
    And I check "Select" for "event220680184, event220804867"
    And I click on the "Add Events" button
    Then I should be on the "Calendar" page
    And the Meetup events "'Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! ' 'Walk the Moon'" should exist
    #And I should see the message "These events are already in the Calendar, and are up to date."

    @repeated_changed_pull_third_events
  Scenario: successfully pull updated events
    Given I already pulled by group_urlname: "220680184"
    And the Meetup event Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! is renamed to Wisps
    And I searched events by group_urlname: "LiveMusicSF"
    And I check "Select" for "event220680184, event220804867"
    And I click on the "Add Events" button
    Then I should be on the "Calendar" page
    And the Meetup event "Wisps" should exist
    And the Meetup event "'Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! '" should not exist
   # And I should see the message "Successfully added: Wisps"






