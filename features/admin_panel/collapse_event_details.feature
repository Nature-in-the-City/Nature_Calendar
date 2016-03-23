# in features/admin_panel/collapse_event_details.feature
@admin_panel
Feature: Hide the details of events displayed in the admin panel
  As an admin
  So that the admin panel isn’t cluttered
  I want to be able to collapse and expand event details
  
Background:
  Given the following events exist:
  | name  | start         | end           | st_number | st_name   | city  | description   | status    | contact_email |
  | Hike1 | Dec-21-2016   | Dec-21-2016   | 1210      | street rd | SF    | A hike        | approved  | joe@cnn.com   |
  | Hike2 | Dec-25-2016   | Dec-25-2016   | 1210      | street rd | SF    | A hike        | pending   | joe@cnn.com   |
  | Hike3 | Dec-27-2016   | Dec-27-2016   | 1210      | street rd | SF    | A hike        | rejected  | joe@cnn.com   |
  | Hike4 | Dec-30-2016   | Dec-30-2016   | 1210      | street rd | SF    | A hike        | approved  | joe@cnn.com   |
  | Hike5 | Dec-31-2016   | Dec-31-2016   | 1210      | street rd | SF    | A hike        | approved  | joe@cnn.com   |

  And   I am logged in as the admin
  And   I see the "Admin" panel
  And   the date is "12/25/2016 06:00:00 AM"
  And I am displaying the "Upcoming" events

Scenario: Event details should be collapsed when you first visit the page
  Then  I should see "Hike4"
  And   the details of "Hike4" should be hidden
  When  I press the "Rejected" tab
  Then  I should see "Hike3"
  And   the details of "Hike3" should be hidden
  
Scenario: Event details should be visible when you click "Show More"
  Then  I should see "Hike4"
  And   the details of "Hike4" should be hidden
  When  I press "Show More" on "Hike4"
  Then  the details of "Hike4" should not be hidden

Scenario: Event details should be hidden again when you click "Show Less"
  When I display the details of "Hike4"
  When I press "Show Less" on "Hike4"
  Then the details of "Hike4" should be hidden

Scenario: Displayed event details should be displayed after returning from another tab
  When I press "Show More" on "Hike4"
  Then I press the "Past" tab
  And I press "Show More" on "Hike1"
  When I press the "Upcoming" tab
  Then the details of "Hike4" should not be hidden
  But the details of "Hike5" should be hidden
