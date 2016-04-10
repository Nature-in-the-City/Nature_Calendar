@sync @javascript
Feature:
  As a Super Admin
  I can approve pending events
  Or I can reject and delete them
  
  Background:
    Given the following events exist:
    | name  | start       | end         | st_number | st_name   | city  | description     | status    | contact_email |
    | Hike  | Dec-21-2016 | Dec-21-2016 | 1210      | street rd | SF    | A past hike     | past      | joe@cnn.com   |
    | Hike1 | Dec-22-2016 | Dec-22-2016 | 1210      | street rd | SF    | A past hike     | past      | joe@cnn.com   |
    | Hike2 | Dec-25-2016 | Dec-25-2016 | 1210      | street rd | SF    | A pending hike  | pending   | joe@cnn.com   |
    | Hike3 | Dec-26-2016 | Dec-26-2016 | 1210      | street rd | SF    | A pending hike  | pending   | joe@cnn.com   |
    | Hike4 | Dec-27-2016 | Dec-27-2016 | 1210      | street rd | SF    | A rejected hike | rejected  | joe@cnn.com   |
    | Hike5 | Dec-28-2016 | Dec-28-2016 | 1210      | street rd | SF    | A rejected hike | rejected  | joe@cnn.com   |
    | Hike6 | Dec-30-2016 | Dec-30-2016 | 1210      | street rd | SF    | Approved hike   | approved  | joe@cnn.com   |
    | Hike7 | Dec-26-2016 | Dec-26-2016 | 1210      | street rd | SF    | Approved hike   | approved  | joe@cnn.com   |
    
    And I log in as Super Admin
    And I see the Admin panel

  Scenario: Approve Pending Events
    Given I press the "Pending" tab
    Then I see the "Pending" event "Hike3"
    When I click "accept"
    And I press the "Accepted" tab
    Then I should see the "Accepted" event "Hike3"
    
  Scenario: Regect Pending Events
    Given I press the "Pending" tab
    Then I see the "Pending" event "Hike2"
    When I click "regect"
    And I press the "Rejected" tab
    Then I see the "Rejected" event "Hike2"
    
  Scenario: Delete Rejected Events
    Given I press the "Rejected" tab
    Then I see the "Rejected" event "Hike5"
    When I click "delete"
    Then I should not see "Hike5"