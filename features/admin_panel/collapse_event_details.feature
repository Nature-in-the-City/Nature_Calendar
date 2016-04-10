# in features/admin_panel/collapse_event_details.feature
@admin_panel @javascript
Feature: Hide the details of events displayed in the admin panel
  As an admin
  So that the admin panel isn’t cluttered
  I want to be able to collapse and expand event details
  
Background:
  Given the following events exist:
  | name  | start         | end           | st_number | st_name   | city  | description   | status    | contact_email |
  | HikeA | Dec-21-2016   | Dec-21-2016   | 1210      | street rd | SF    | A hike        | past      | joe@cnn.com   |
  | Hike1 | Dec-25-2016   | Dec-25-2016   | 1211      | street rd | SF    | A hike        | pending   | joe@cnn.com   |
  | HikeB | Dec-27-2016   | Dec-27-2016   | 1212      | street rd | SF    | A hike        | rejected  | joe@cnn.com   |
  | Hike2 | Dec-30-2016   | Dec-30-2016   | 1213      | street rd | SF    | A hike        | approved  | joe@cnn.com   |
  | HikeC | Dec-31-2016   | Dec-31-2016   | 1214      | street rd | SF    | A hike        | approved  | joe@cnn.com   |

  And I am logged in as the admin
  And I see the "Admin" panel
  And I am displaying the "Upcoming" events

Scenario: Event details should be collapsed when you first visit the page
  Given I see the "Upcoming" event "Hike2"
  Then I should see a link to "Show More" details for "Hike2"
  And the details of "Hike2" should be hidden
  When I press the "Rejected" tab
  Then I should see "HikeB"
  And I should see a link to "Show More" details for "HikeB"
  And the details of "HikeB" should be hidden
  
Scenario: Event details should be visible when you click "Show More"
  Given I see the "Upcoming" event "HikeC"
  And the details of "HikeC" should be hidden
  When I "Show More" details on "HikeC"
  Then the details of "HikeC" should not be hidden

Scenario: Event details should be hidden again when you click "Show Less"
  Given I see the "Upcoming" event "Hike2"
  When I display the details for "Hike2"
  And I "Show Less" details on "Hike2"
  Then I should see a link to "Show More" details for "Hike2"
  #And the details of "Hike2" should be hidden

Scenario: Displayed event details should be displayed after returning from another tab
  Given I see the "Upcoming" event "HikeC"
  When I "Show More" details on "HikeC"
  Then the details of "HikeC" should not be hidden
  When I press the "Past" tab
  And I press the "Upcoming" tab
  And I see the "Upcoming" event "HikeC"
  Then the details of "HikeC" should not be hidden
  But the details of "Hike2" should be hidden