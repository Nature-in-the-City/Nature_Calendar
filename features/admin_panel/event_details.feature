@admin_panel
Feature: View event details on the admin page.
	As an admin user
	So that I see all of the details of an event
	I want to see each event's details displayed below it in the event list on the admin panel

Background: Events have already been added to the database
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

Scenario: Display upcoming event details
  Given I am displaying the "Upcoming" events
  Then  I should see "Hike4"
  And   I should see the following details displayed below "Hike4":  "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events: "Hike1", "Hike2", "Hike3"
  
Scenario: Display pending event details
  Given I am displaying the "Pending" events
  Then  I should see "Hike2"
  And   I should see the following details displayed below "Hike2": "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events: "Hike1", "Hike3", "Hike4"

Scenario: Display rejected event details
  Given I am displaying the "Rejected" events
  Then  I should see "Hike3"
  And   I should see the following details displayed below "Hike3": "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events: "Hike1", "Hike2", "Hike4"

Scenario: Display past event details
  Given I am displaying the "Past" events
  Then  I should see "Hike1"
  And   I should see the following details displayed below "Hike1": "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events: "Hike2", "Hike3", "Hike4"
