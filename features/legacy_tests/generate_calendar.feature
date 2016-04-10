@javascript @legacy
Feature: Display a calendar

  As a user,
  So that I can view the events in a clean and concise matter,
  I want to be able to see a calendar

Scenario: see current month and year
  Given I am on the calendar page
  And the month is April 2015
  Then the month should be April 2015
  And the first day should be Wednesday
  And the last day should be Thursday

Scenario: go to previous month's calendar
  Given I am on the calendar page
  And the month is April 2015
  When I click on the calendar's previous arrow
  Then the month should be March 2015
  And the first day should be Sunday
  And the last day should be Tuesday

Scenario: go to next month's calendar
  Given I am on the calendar page
  And the month is April 2015
  When I click on the calendar's next arrow
  Then the month should be May 2015
  And the first day should be Friday
  And the last day should be Sunday 
