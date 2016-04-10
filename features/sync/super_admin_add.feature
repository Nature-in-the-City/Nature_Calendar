@sync @javascript
Feature:
  As a Super Admin
  I can create other admins
  As new Super Admins or Regular Admins
  
  Background:
    Given I am logged in as a Super Admin
    And I see the Admin panel
    
  Scenario: Create new Super Admins
    Given I follow "Create New Account"
    And I fill in email with "sup@admin.com"
    And I fill in password with "green"
    And I check "Super Admin"
    And I click "Create User"
    Then I should be on the Calendars Page
    And I should see "User successfully created!"
    
  Scenario: Create new Regular Admins
    Given I follow "Create New Account"
    And I fill in email with "reg@admin.com"
    And I fill in password with "yellow"
    And I click "Create User"
    Then I should be on the Calendars Page
    And I should see "User successfully created!"
    
  Scenario: Login as a new user
    Given the following users exist:
      | email            | password       | level     | reset_password_token |
      | mike@admin.com   | greenman       | 0         | 'token'              |
      | ping@dmin.com    | feelman        | 1         | 'token'              |
    
    And I am on the Calendars Page
    When I click "Sign In"
    And I fill in email with "mike@admin.com"
    And I fill in password with "greenman"
    And I click "Log In"
    Then I should see the Admin panel
    And I should see "Add New Users"