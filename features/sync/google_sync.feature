@sync
Feature:
  As an admin user
  So I can make all nature events in SF available on my calendar
  I want to be able to sync events with other organizations’ Google calendars
  
  Background:
    Given I am logged in as the admin
    And I see the "Sync Status" panel
      
  Scenario: Add Google calendar to be linked to the database
    When I fill in "URL" with "http://googlecalendarlink.com/link_to=1232312"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Calendar successfully added for syncing"
    
  Scenario: Bad Google calendar links should redirect with message
    When I fill in "URL" with "http://badcalendarlink.com/fail_to/link_to=1232312"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Calendar link unsuccessful: Invalid URL"
    
  Scenario: Events of linked Google Calendars should auto-populate
    Given the following calendars have been linked:
      | name        | url                       |
      | NatureGroup | http://groupurl.com/link1 |
    Then I should see events from "NatureGroup"
    And I should see the event "NatureGroup Meetup".