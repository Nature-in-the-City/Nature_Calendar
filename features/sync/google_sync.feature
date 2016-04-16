@javascript
Feature:
  As an admin user
  So I can make all nature events in SF available on my calendar
  I want to be able to sync events with other organizations’ Google calendars
  
  Background:
    Given I am logged in as the admin
    And I see the "Sync Status" panel
      
  Scenario: Add Google calendar to be linked to the database
    When I fill in "url" with "http://calendar.google.com/link_to=1232312"
    And I press "Add"
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://calendar.google.com/link_to=1232312'!"
    
  Scenario: Bad Google calendar links should redirect with message
    When I fill in "url" with "http://badcalendarlink.com/fail_to/link_to=1232312"
    And I press "Add"
    Then I should be on the "Admin" page
    And I should see "Could not sync 'http://badcalendarlink.com/fail_to/link_to=1232312': Invalid URL"