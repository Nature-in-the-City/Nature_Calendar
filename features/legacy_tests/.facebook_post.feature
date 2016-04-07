@javascript @legacy
Feature: push new calendar events to Facebook

  As an admin of the website
  To increase the social exposure of my events
  I want to have events I create on the calendar automatically be posted on Facebook

  Background: create a new event
    Given I am logged in as the admin
    And I am an authorized organizer of the group
    And I am on the "Create" page
    And I fill in the "Event Name" field with "Nature Walk"
    And I fill in the "Venue Name" field with "Steps"
    And I fill in the "Address" field with "145 Jackson st"
    And I fill in the "City" field with "Glendale"
    And I fill in the "Zip" field with "90210"
    And I select "8/18/2015, 4:30pm" as the "start" date and time
    And I select "8/22/2015, 4:30pm" as the "end" date and time
    And I fill in the "Description" field with "Join us for a nature walk through old town Los Angeles!"
    And I fill in the "How to find us" field with "Turn right at Sunset and Vine"

  
  Scenario: successfully post the newly created event on Facebook
    Given I click on the "Create Event" button
    Then I should be on the "Calendar" page
    And I should see the message "'Nature Walk' was successfully added and pushed to Meetup and Facebook."
    And the "Nature Walk" event should be posted on "Nature in the City" facebook page

  
  Scenario: failed push of newly created event to Meetup (implemented as a transaction)
    Given I click on the "Create Event" button
    Then I should be on the "Calendar" page
    And I should see the message "Failed to push event 'Nature Walk' to Meetup. Creation aborted."
    And the "Nature Walk" event should not be posted on "Nature in the City" facebook page

  
  Scenario: failed push of newly created event on Facebook (not implemented as a transaction)
    Given I click on the "Create Event" button
    Then I should be on the "Calendar" page
    And I should see the message "'Nature Walk' was successfully added and pushed to Meetup."
    And the "Nature Walk" event should not be posted on "Nature in the City" facebook page
