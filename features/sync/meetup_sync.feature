@sync @javascript
Feature:
  As an admin user
  So I can make all nature events in SF available on my calendars
  I want to be able to sync events with other organizations’ Meetup calendars
  
  Background:
    Given I am logged in as the admin
    And I see the "Sync Status" panel
  
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "sync_url" field with "http://meetup.com/Nature-in-the-City"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://meetup.com/Nature-in-the-City'!"
    
  Scenario: Incorrect Meetup URLs should redirect with a message
    When I fill in the "sync_url" field with "http://www.meetup.com/codeselfstudy/"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://www.meetup.com/codeselfstudy/'!"
    
  Scenario: Exsiting synced Meetup groups should be linked when I refresh the page
    Given the following calendars have been linked:
      | organization                                      | url                                                             |
      | Practical Heart Centered Personal Growth          | http://www.meetup.com/Practical-Heart-Centered-Personal-Growth/ |
    
    Then I should see "Practical Heart Centered Personal Growth" in the "Sync Status" panel