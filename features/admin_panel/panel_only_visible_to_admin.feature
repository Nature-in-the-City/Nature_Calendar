@javascript @admin_panel
Feature: Admin page features should only be visible to admin users
  As an admin
  So that I can keep admin capabilites separate from the public
  I want the admin and sync panels, and add users button to be visible to only logged in admin users

Scenario: I can only see the calendar when I am not logged in
  Given I am not logged in as an admin
  And I am on the calendar page
  Then I should not see the admin panel
  And I should not see the sync panel
  And I should not see the add users button

Scenario: I can see the admin features once I have logged in
  Given I am logged in as an admin
  And I am on the calendar page
  Then I should see the admin panel
  And I should see the sync panel
  And I should see the "Add Users" button