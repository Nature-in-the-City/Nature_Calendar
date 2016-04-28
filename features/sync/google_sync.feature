@sync @javascript
Feature:
  As an admin user
  So I can make all nature events in SF available on my calendar
  I want to be able to sync events with other organizations’ Google calendars
  
  Background:
    Given I am logged in as the admin
    And I see the "Sync" panel
      
  Scenario: Add Google calendar to be linked to the database
    When I fill in the "sync_url" field with "http://calendar.google.com/link_to=1232312"
    And I press "Add Calendar"
    And I see the "Sync" panel
    And I should see "Successfully synced 'http://calendar.google.com/link_to=1232312'!"
    
  Scenario: Add Google calendar to be linked to the database
    When I fill in the "sync_url" field with "http://calendar.google.com/link_to=2136662"
    And I press "Add Calendar"
    And I see the "Sync" panel
    And I should see "Successfully synced 'http://calendar.google.com/link_to=2136662'!"
  
  Scenario: Add Google calendar to be linked to the database
    When I fill in the "sync_url" field with "http://calendar.google.com/link_to=4546263"
    And I press "Add Calendar"
    And I see the "Sync" panel
    And I should see "Successfully synced 'http://calendar.google.com/link_to=4546263'!"
    
  Scenario: Bad Google calendar links should redirect with message
    When I fill in the "sync_url" field with "http://badcalendarlink.com/fail_to/link_to=1232312"
    And I press "Add Calendar"
    And I see the "Sync" panel
    And I should see "Could not sync 'http://badcalendarlink.com/fail_to/link_to=1232312': Invalid URL"
  
  Scenario: Bad Google calendar links should redirect with message
    When I fill in the "sync_url" field with "http://badcalendarlink.com/fail_to/link_to=2136662"
    And I press "Add Calendar"
    And I see the "Sync" panel
    And I should see "Could not sync 'http://badcalendarlink.com/fail_to/link_to=2136662': Invalid URL"
  
  Scenario: Bad Google calendar links should redirect with message
    When I fill in the "sync_url" field with "http://badcalendarlink.com/fail_to/link_to=4546263"
    And I press "Add Calendar"
    And I see the "Sync" panel
    And I should see "Could not sync 'http://badcalendarlink.com/fail_to/link_to=4546263': Invalid URL"