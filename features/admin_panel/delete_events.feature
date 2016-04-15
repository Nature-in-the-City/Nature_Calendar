# in features/admin_panel/delete_events.feature
@admin_panel @javascript
Feature: Delete events
  As an admin
  So that I can remove cancelled or obsolete events from the calendar
  I want to be able to delete events on the calendar
  
Background:
  Given the following events exist:
  | name  | start               | end                   | status    |
  | Hike  | Dec-31-2016 01:00pm | Dec-31-2016 03:00pm   | approved  |
  | Walk  | Dec-30-2016 01:00pm | Dec-30-2016 03:00pm   | past      |
  | Think | May-30-2016 2:00pm  | May-30-2016 7:00pm    | pending   |

  And I am logged in as the admin
  And I see the Admin panel

Scenario: Admin can reject upcoming events
  Given the month is December 2016
  Then I should see "Hike"
  Given I am displaying the "Upcoming" events
  And I display the details for "Hike"
  When I click the "reject" button on "Hike"
  Then the "Hike" event status should be "rejected"
  Given the month is Decemeber 2016
  Then I should not see "Hike"
  When I press the "Rejected" tab
  Then I should see "Hike"

Scenario: Admin can delete past events
  Given I am displaying the "Past" events
  When I display the details for "Walk"
  And I click the "delete" button on "Walk"
  Then the "Walk" event should be deleted
  Given I am displaying the "Past" events
  Then I should not see "Walk"

Scenario: Admin can delete rejected events
  Given I have rejected the "Hike" event
  And I am displaying the "Rejected" events
  Then I should see "Hike"
  When I display the details for "Hike"
  And I click the "delete" button on "Hike"
  Then the "Hike" event should be deleted
