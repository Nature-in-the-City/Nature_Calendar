@admin_panel @javascript
Feature: View events by status on the admin page.
	As an admin user
	So that I can easily switch between events of different status groups
	I want to see the events categorized under past, upcoming, pending, and rejected tabs

Background: Events have already been added to the database
  Given the following events exist:
  | name  | start       | end         | st_number | st_name   | city  | description     | status    | contact_email |
  | Hike  | Dec-21-2015 | Dec-21-2015 | 1210      | street rd | SF    | A past hike     | approved  | joe@cnn.com   |
  | Hike1 | Dec-22-2015 | Dec-22-2015 | 1210      | street rd | SF    | A past hike     | approved  | joe@cnn.com   |
  | Hike2 | Dec-25-2016 | Dec-25-2016 | 1210      | street rd | SF    | A pending hike  | pending   | joe@cnn.com   |
  | Hike3 | Dec-26-2016 | Dec-26-2016 | 1210      | street rd | SF    | A pending hike  | pending   | joe@cnn.com   |
  | Hike4 | Dec-27-2016 | Dec-27-2016 | 1210      | street rd | SF    | A rejected hike | rejected  | joe@cnn.com   |
  | Hike5 | Dec-28-2016 | Dec-28-2016 | 1210      | street rd | SF    | A rejected hike | rejected  | joe@cnn.com   |
  | Hike6 | Dec-30-2016 | Dec-30-2016 | 1210      | street rd | SF    | Approved hike   | approved  | joe@cnn.com   |
  | Hike7 | Dec-26-2016 | Dec-26-2016 | 1210      | street rd | SF    | Approved hike   | approved  | joe@cnn.com   |

  And I am logged in as the admin
  And I see the Admin panel
  And I see the following status tabs: "Upcoming", "Pending", "Rejected", "Past"
  And the date is "12/25/2016 06:00:00 AM"

Scenario: Show upcoming events in ascending order
  Given I press the "Upcoming" tab
  Then I see the "Upcoming" event "Hike6"
  And I should see "Hike7" before "Hike6"
  And I should not see "Hike1"

Scenario: Show past events in descending order
  Given I press the "Past" tab
  Then I see the "Past" event "Hike1"
  And I should see "Hike1" before "Hike"
  And I should not see "Hike6"
  And I should not see "Hike4"

Scenario: Show pending events in ascending order
  Given I press the "Pending" tab
  Then I see the "Pending" event "Hike3"
  And I should see "Hike2" before "Hike3"
  And I should not see "Hike4"
  And I should not see "Hike6"
  
Scenario: Show rejected events in ascending order
  Given I press the "Rejected" tab
  Then I see the "Rejected" event "Hike4"
  And I should see "Hike4" before "Hike5"
