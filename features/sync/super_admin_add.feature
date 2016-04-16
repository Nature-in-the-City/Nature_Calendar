@sync @javascript
Feature:
  As a Super Admin
  I can create other admins
  As new Regular Admins or Super Admins
  
  Background:
    Given I log in as Super Admin
    And I see the Admin panel
    
  Scenario: Create new Super Admins
    Given I create super admin "sup@admin.com" with password "greeneggs"
    Then I should see "sup@admin.com successfully created!"
    
  Scenario: Create new Regular Admins
    Given I create regular admin "reg@admin.com" with password "yelloRung"
    Then I should see "reg@admin.com successfully created!"
    
  Scenario: Login as a new user
    Given the following users exist:
      | email            | password       | level     | reset_password_token |
      | mike@admin.com   | greenman       | 0         | 'token'              |
      | ping@dmin.com    | feelmannar     | 1         | 'token'              |
    
    And I am not logged in as the root admin
    When I sign in as "mike@admin.com" with password "greenman"
    And I see the Admin panel