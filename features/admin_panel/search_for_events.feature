@javascript @admin_panel @inprog
Feature: Search for events in admin panel
  As an admin
  So that I can quickly find a specific event
  I want to be able to search for a specific event in the admin panel
  
Background:
  Given the following events exist:
    | name                    | start                 | end                 | status    |
    | Hike in the city        | Aug-21-2018 12:00 PM  | Aug-21-2018 4:00 PM | pending   |
    | Rollerblade in the park | Aug-31-2018 9:00 AM   | Aug-31-2018 1:00 PM | approved  |
    And I am logged in as the admin
    And I see the "Admin" panel
    And I press the "Search" tab
    And I see the search bar

Scenario: search for event by name
  And I fill in "Hike in the city" in "Search"
  And I click "Search"
  Then I should see "Hike in the city" in the results panel
  
Scenario: search for event by name (sad path)
  And I fill in "nil" in "Search"
  And I click "Search"
  Then I should see "Sorry, no events were found" in the results panel

Scenario: search for event by name with incorrect name
  And I fill in "hike in the citie" in "Search"
  And I click "Search"
  Then I should see "Sorry, no events were found" in the results panel
