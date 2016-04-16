# in features/admin_panel/edit_event_details.feature
@admin_panel @javascript @inprogress
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
  When I click the edit button on "Nature Hike"
  Then the "edit" window for "Nature Hike" should be open
  When I fill in "Start" date for "Nature Hike" with "December 31 2016 02:00:PM"
  And I fill in "End" date for "Nature Hike" with "December 31 2016 04:00:PM"
  And I click "Update Event" for "Nature Hike"
  When I "Show More" details on "Nature Hike"
  And I have opened the edit window for "Nature Hike"
  Then the "Start" date for "Nature Hike" should be "December 31 2016 02:00:PM"
  And the "End" date for "Nature Hike" should be "December 31 2016 04:00:PM"
  
Scenario: Admin can edit and save the location
  Given I have opened the edit window for "Nature Hike"
  When I fill in "event[contact_first]" for "Nature Hike" with "Elmo"
  And I click "Update Event" for "Nature Hike"
  When I "Show More" details on "Nature Hike"
  And I have opened the edit window for "Nature Hike"
  Then "event_contact_first" for "Nature Hike" should be "Elmo"

Scenario: Admin can edit and save the description
  Given I have opened the edit window for "Nature Hike"
  And "event_description" for "Nature Hike" is "A nature hike"
  When I fill in "event[description]" for "Nature Hike" with "The best nature hike ever!"
  And I click "Update Event" for "Nature Hike"
  When I "Show More" details on "Nature Hike"
  And I have opened the edit window for "Nature Hike"
  Then "event_description" for "Nature Hike" should be "The best nature hike ever!"
