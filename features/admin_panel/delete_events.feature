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
  And I see the "Admin" panel

Scenario: Admin can delete upcoming events
  
  Given I am displaying the "Upcoming" events
  And I "Show More" details on "Nature Hike"
  And I click "Trash" for "Nature Hike"
  Then The "Nature Hike" event should be deleted

Scenario: Admin can delete past events
  
  Given I am displaying the "Past" events
  And I "Show More" details on "Nature Walk"
  And I click "Trash" for "Nature Walk"
  Then The "Nature Walk" event should be deleted
