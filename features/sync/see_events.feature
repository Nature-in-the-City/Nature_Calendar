@sync @javascript
Feature:
  As an admin user
  If I have synced a google or meetup calendar
  I should see the events on that calendar

  Background:
    Given I am logged in as the admin
    And I see the "Sync Status" panel

  Scenario: Events of linked Meetup Calendars should auto-populate
    Given the following calendars have been linked:
      | organization    | url                               |
      | NatureGroup     | http://meetup.com/123456789       |
    Then I should see events from "NatureGroup"
    And I should see the event "NatureGroup Meetup".
    
  Scenario: Events of linked Google Calendars should auto-populate
    Given the following calendars have been linked:
      | organization      | url                              |
      | GreenEarth        | http://calendar.google.com/link1 |
    Then I should see events from "GreenEarth"
    And I should see the event "NatureGroup Meetup".

