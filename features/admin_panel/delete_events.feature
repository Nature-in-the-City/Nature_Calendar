# in features/admin_panel/delete_events.feature
@admin_panel @javascript
Feature: Delete events
  As an admin
  So that I can remove cancelled or obsolete events from the calendar
  I want to be able to delete events on the calendar
  
Background:
  Given the following events exist:
  | name        | start               | end                  | st_number | st_name    | city          | zip   | description   | status   | contact_email |
  | Nature Hike | Dec-31-2016 01:00pm | Dec-31-2016 03:00pm  | 1214      | Cherry St. | San Francisco | 94103 | A nature hike | approved | joe@cnn.com   |
  | Nature Walk | Dec-30-2016 01:00pm | Dec-30-2016 03:00pm  | 1214      | Cherry St. | San Francisco | 94103 | A nature walk | past     | joe@cnn.com   |

  And I am logged in as the admin
  And I see the Admin panel

Scenario: Admin can reject upcoming events
  Given the month is December 2016
  Then I should see "Nature Hike"
  Given I am displaying the "Upcoming" events
  And I display the details for "Nature Hike"
  When I click the "reject" button on "Nature Hike"
  Then the "Nature Hike" event status should be "rejected"
  Given the month is Decemeber 2016
  Then I should not see "Nature Hike"
  When I press the "Rejected" tab
  Then I should see "Nature Hike"

Scenario: Admin can delete past events
  Given I am displaying the "Past" events
  When I display the details for "Nature Walk"
  And I click the "delete" button on "Nature Walk"
  Then the "Nature Walk" event should be deleted
  Given I am displaying the "Past" events
  Then I should not see "Nature Walk"

Scenario: Admin can delete rejected events
  Given I have rejected the "Nature Hike" event
  And I am displaying the "Rejected" events
  Then I should see "Nature Hike"
  When I display the details for "Nature Hike"
  And I click the "delete" button on "Nature Hike"
  Then the "Nature Hike" event should be deleted
