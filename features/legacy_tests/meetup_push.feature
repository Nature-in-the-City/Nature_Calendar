@javascript
@meetup_push
Feature: push new calendar events to meetup

    As an admin of the website
    To guarantee I don't have to maintain two sets of identical events
    I want to have events I create on the calendar automatically push to Meetup

  Background: create a new event
    Given I am logged in as the admin
    And I am an authorized organizer of the group
    And I am on the calendar page
    And I click on the "+" button
    And I fill in the "Name" field with "Nature Walk"
    And I check "Enable Venue"
    And I fill in the "autocomplete" field with "145 N Jackson st Glendale 91206"
    And I accept the google maps suggested address
    And I select "8/18/2015, 4:30pm" as the "start" date and time
    And I select "8/22/2015, 4:30pm" as the "end" date and time
    And I fill in the "Description" field with "Join us for a nature walk through old town Los Angeles!"
    And I fill in the "How to find us" field with "Turn right at Sunset and Vine"

  @successful_push
  Scenario: successfully push the newly created event to Meetup
      Given I click on the "Create Event" button
      Then I should see the message "Successfully added 'Nature Walk'!"
      And the "Nature Walk" event should exist on "both" platforms

  @failed_push
  Scenario: failed push of newly created event to Meetup (Implemented as a transaction)
      Given I click on the "Create Event" button
      And I should see the javascript message "Could not create 'Nature Walk'"
      And the "Nature Walk" event should exist on "neither" platforms


  # NOTE: The pull feature already handles the case in which an admin creates a new event on Meetup, and this event
  #       is then automatically pulled on the Calendar
