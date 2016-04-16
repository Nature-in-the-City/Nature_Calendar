@sync @javascript
Feature:
  As an admin user
  So I can make all nature events in SF available on my calendars
  I want to be able to sync events with other organizations’ Meetup calendars
  
  Background:
    Given I am logged in as the admin
    And I see the "Sync Status" panel
  
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "sync_url" field with "http://www.meetup.com/Truve-Oakland-Exercise-Meetup/"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://www.meetup.com/Truve-Oakland-Exercise-Meetup/'!"
    
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "sync_url" field with "http://www.meetup.com/codeselfstudy/"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://www.meetup.com/codeselfstudy/'!"