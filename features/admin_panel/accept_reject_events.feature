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
  And I am logged in as the admin
  And I see the Admin panel
  And I see the following status tabs: "Upcoming", "Pending", "Rejected", "Past"

Scenario: Accept an event
  Given that I press the "Pending" tab
  Then I should see the "Pending" event "Imagination rafing"
  When I "Show More" details on "Imagination rafting"
  And I follow "Imagination rafting"'s "accept" button
  Then I should see the "Upcoming" event "Imagination rafting"
  When I press the "Pending" tab
  Then I should see "Real life running"

Scenario: Reject an accepted event
  Given that I see the "Upcoming" event "Sleep walking"
  When I "Show More" details on "Sleep walking"
  And I follow "Sleep walking"'s "reject" button
  When I press the "Rejected" tab
  Then I should see "Insomniac"