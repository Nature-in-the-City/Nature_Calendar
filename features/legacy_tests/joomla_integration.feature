Feature: Have our calendar integrate with Joomla template
  As a user
  So that when I navigate to the calendar page
  The style of the page remains consistent with the rest of the Joomla site

Background: Events have already been added to the database

Scenario: user is on calendar page
Given I am on the "Calendar" page
Then I should see "Home" on the page

Scenario: sad path
Given there is an error requesting the joomla site
And I am on the "Calendar" page
Then I should see "Home" on the page
