# in features/admin_panel/edit_event_details.feature
@admin_panel @javascript
Feature: Edit the details of events displayed in the admin panel
  As an admin user
  So I can update the information for an event
  I want to be able to edit event details directly from the admin panel
  
Background:
  Given the following events exist:
  | name        | start               | end                  | st_number | st_name    | city          | zip   | description   | status   | contact_email |
  | Nature Hike | Dec-31-2016 01:00pm | Dec-31-2016 03:00pm  | 1214      | Cherry St. | San Francisco | 94103 | A nature hike | approved | joe@cnn.com   |

  And I am logged in as the admin
  And I see the "Admin" panel
  And I am displaying the "Upcoming" events
  And I "Show More" details on "Nature Hike"

Scenario: Admin can edit and save the start and end times
  Given "Start" for "Nature Hike" is "Dec-31-2016 01:00pm"
  And "End" for "Nature Hike" is "Dec-31-2016 03:00pm"
  When I change "End" for "Nature Hike" to "Dec-31-2016 04:00pm"
  And I change "Start" for "Nature Hike" to "Dec-31-2016 02:00pm"
  And I change "End" for "Nature Hike" to "Dec-31-2016 04:00pm"
  And I click "Save Changes" for "Nature Hike"
  Then "Start" for "Nature Hike" should be "Dec-31-2016 02:00pm"
  And "End" for "Nature Hike" should be "Dec-31-2016 04:00pm"
  
Scenario: Admin can edit and save the location
  Given "Location" for "Nature Hike" is "1214 Cherry St., San Francisco, CA 94103"
  When I change "Location" for "Nature Hike" to "3126 Market St., San Francisco, CA 94103"
  And I click "Save Changes" for "Nature Hike"
  And "Location" for "Nature Hike" should be "3126 Market St., San Francisco, CA 94103"

Scenario: Admin can edit and save the description
  Given "Description" for "Nature Hike" is "A nature hike"
  When I change "Description" for "Nature Hike" to "The best nature hike ever!"
  And I click "Save Changes" for "Nature Hike"
  And "Description" for "Nature Hike" should be "The best nature hike ever!"
