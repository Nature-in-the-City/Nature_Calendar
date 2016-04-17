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