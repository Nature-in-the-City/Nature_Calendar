@javascript @admin_panel
Feature: Approve and reject events
    As an admin
    So that I can choose which suggested events should be displayed on the calendar
    I want to be able to approve or reject pending events from the admin panel

Background:
  Given the following events exist:
    | name                  | organization          | st_number | st_name       | city          | zip   | start                 | end                   | status    |
    | Imagination rafting   | Imagine the outdoors  | 145       | Jackson st    | Riverside     | 90210 | March 19, 2017 16:30  | March 19 2017, 20:30  | pending   |
    | Real life running     | Runner's World        | 45        | Seneca st     | Phoenix       | 91210 | April 20, 2017 8:30   | April 21 2017, 8:30   | pending   |
    | Sleep walking         | Insomniac             | 12345     | Union St      | San Francisco | 94123 | Aug-30-2016 1:00      | Aug-30-2016 3:00      | approved  |
    | WORDS                 | ORG                   | 567       | Hearst Ave    | Berkeley      | 94707 | Apr-10-2017 1:00      | Apr-10-2017 4:00      | rejected  |
  And I am logged in as the admin
  And I see the "Admin" panel

Scenario: Accept a pending event
  Given I am displaying the "Pending" events
  Then I should see the event "Imagination rafting"
  When I display the details for "Imagination rafting"
  And I click the "accept" button on "Imagination rafting"
  Then the "Imagination rafting" event status should be "approved"
  Given the month is March 2017
  Then I should see "Imagination rafting"
  And I should see the "Upcoming" event "Imagination rafting"

Scenario: Reject an accepted event
  Given I am displaying the "Upcoming" events
  Then I should see the event "Sleep walking"
  When I display the details for "Sleep walking"
  And I click the "reject" button on "Sleep walking"
  Then the "Sleep walking" event status should be "rejected"
  Given the month is August 2016
  Then I should not see "Sleep walking"
  When I press the "Rejected" tab
  Then I should see the event "Sleep walking"

Scenario: Accept a rejected event
  Given that I see the "Rejected" event "WORDS"
  When I display the details for "WORDS"
  And I click the "accept" button on "WORDS"
  Then the "WORDS" event status should be "approved"
  Given the month is April 2017
  Then I should see the event "WORDS"
  And I should see the "Upcoming" event "WORDS"
  