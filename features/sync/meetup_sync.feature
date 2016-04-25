@sync @javascript
Feature:
  As an admin user
  So I can make all nature events in SF available on my calendars
  I want to be able to sync events with other organizations’ Meetup calendars
  
  Background:
    Given I am logged in as the admin
    And I see the "Sync" panel
  
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "sync_url" field with "http://www.meetup.com/Truve-Oakland-Exercise-Meetup/"
    And I press "Add Calendar"
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://www.meetup.com/Truve-Oakland-Exercise-Meetup/'!"
    
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "sync_url" field with "http://www.meetup.com/codeselfstudy/"
    And I press "Add Calendar"
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://www.meetup.com/codeselfstudy/'!"
  
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "sync_url" field with "http://www.meetup.com/sanfranciscobay/"
    And I press "Add Calendar"
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://www.meetup.com/sanfranciscobay/'!"
    
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "sync_url" field with "http://www.meetup.com/Women-Who-Code-East-Bay/"
    And I press "Add Calendar"
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://www.meetup.com/Women-Who-Code-East-Bay/"
  
  Scenario: Bad meetup calendar links should redirect with message
    When I fill in the "sync_url" field with "http://badcalendarlink.com/fail_to/link_to=1232312"
    And I press "Add Calendar"
    Then I should be on the "Admin" page
    And I should see "Could not sync 'http://badcalendarlink.com/fail_to/link_to=1232312': Invalid URL"
  
  Scenario: Bad meetup calendar links should redirect with message
    When I fill in the "sync_url" field with "http://badcalendarlink.com/fail_to/link_to=2136662"
    And I press "Add Calendar"
    Then I should be on the "Admin" page
    And I should see "Could not sync 'http://badcalendarlink.com/fail_to/link_to=2136662': Invalid URL"
  
  Scenario: Bad meetup calendar links should redirect with message
    When I fill in the "sync_url" field with "http://badcalendarlink.com/fail_to/link_to=4546263"
    And I press "Add Calendar"
    Then I should be on the "Admin" page
    And I should see "Could not sync 'http://badcalendarlink.com/fail_to/link_to=4546263': Invalid URL"