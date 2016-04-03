@sync @javascript
Feature:
  As an admin user
  So I can make all nature events in SF available on my calendars
  I want to be able to sync events with other organizations’ Meetup calendars
  
  Background:
    Given I am logged in as the admin
    And I see the "Sync Status" panel
  
  Scenario: I should be able to add a meetup calendar to sync with by URL
    When I fill in the "URL" field with "http://meetup.com/123456789"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://meetup.com/123456789'!"
    
  Scenario: Incorrect Meetup URLs should redirect with a message
    When I fill in the "URL" field with "http://meetup.com/0000000"
    And I press the "Add" button
    Then I should be on the "Admin" page
    And I should see "Successfully synced 'http://meetup.com/0000000'!"
    
  Scenario: Exsiting synced Meetup groups should be linked when I refresh the page
    Given the following calendars have been linked:
      | organization      | url                         | calendar_id |
      | Outdoors          | http://meetup.com/18264738  | 12786890    |
    When I visit the "Admin" page
    Then I should see "Outdoors" in the "Sync Status" panel