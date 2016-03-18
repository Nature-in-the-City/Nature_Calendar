Feature: authentication for our application

  As an admin,
  So that I can access actions that alter the behavior of the calendar,
  I want to be able to login to the application

Scenario: Guests should not see admin actions
  Given I am not logged in as the admin
  Then  I should not see the admin actions

Scenario: Admins should be able to login with proper credentials
  Given I am not logged in as the admin
  When  I sign in with valid credentials
  Then  I should see the "Sign Out" link

Scenario: Admins should not be able to login with improper credentials
  Given I am not logged in as the admin
  When  I sign in with the wrong password
  Then  I should be on the "Sign In" page

Scenario: Admins should be able to logout
  Given I am logged in as the admin
  When  I click on the "Sign Out" link
  Then  I should see "Signed out successfully" on the page

Scenario: Admins should see admin actions
  Given I am logged in as the admin
  And   I am on the "Calendar" page
  Then  I should see the admin actions
