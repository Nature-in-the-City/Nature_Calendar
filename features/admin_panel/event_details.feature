@admin_panel @javascript
Feature: View event details on the admin page.
	As an admin user
	So that I see all of the details of an event
	I want to see each event's details displayed below it in the event list on the admin panel

Background: Events have already been added to the database
  Given the following events exist:
  | name  | start         | end           | st_number | st_name   | city  | description   | status    | contact_email |
  | Hike1 | Jan-21-2015   | Jan-21-2015   | 1210      | street rd | SF    | A hike        | approved  | joe@cnn.com   |
  | Hike2 | Dec-25-2016   | Dec-25-2016   | 1210      | street rd | SF    | A hike        | pending   | joe@cnn.com   |
  | Hike3 | Dec-27-2016   | Dec-27-2016   | 1210      | street rd | SF    | A hike        | rejected  | joe@cnn.com   |
  | Hike4 | Dec-30-2016   | Dec-30-2016   | 1210      | street rd | SF    | A hike        | approved  | joe@cnn.com   |
  | Hike5 | Dec-31-2016   | Dec-31-2016   | 1210      | street rd | SF    | A hike        | approved  | joe@cnn.com   |
  
  And I am logged in as the admin
  And I see the "Admin" panel

Scenario: Display upcoming event details
  Given I am displaying the "Upcoming" events
  Then I should see "Hike4"
  When I display the details for "Hike4"
  And I should see "Hike4" details, including: Start, End, Location, Description, Email
  But I should not see the following events: "Hike1", "Hike2", "Hike3"
  
Scenario: Display pending event details
  Given I am displaying the "Pending" events
  Then I should see "Hike2"
  When I display the details for "Hike2"
  Then I should see "Hike2" details, including: Start, End, Location, Description, Email
  But I should not see the following events: "Hike1", "Hike3", "Hike4"

Scenario: Display rejected event details
  Given I am displaying the "Rejected" events
  Then I should see "Hike3"
  When I display the details for "Hike3"
  Then I should see "Hike3" details, including: Start, End, Location, Description, Email
  But  I should not see the following events: "Hike1", "Hike2", "Hike4"

Scenario: Display past event details
  Given I am displaying the "Past" events
  Then I should see "Hike1"
  When I display the details for "Hike1"
  Then I should see "Hike1" details, including: Start, End, Location, Description, Email
  But I should not see the following events: "Hike2", "Hike3", "Hike4"
