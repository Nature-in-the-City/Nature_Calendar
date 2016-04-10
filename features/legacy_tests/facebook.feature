@javascript @legacy
Feature: push new calendar events to Facebook

  As an admin of the website
  To increase the social exposure of my events
  I want to have events I create on the calendar automatically be posted on Facebook

Background:
  Given I am logged in as the admin
  And I am an authorized organizer of the group
  And I am on the "Calendar" page
  And I create a new event called "Walkathon"
  And the event takes place on "April 2, 2015"

Scenario: successfully post the newly created event on Facebook
  Given I click on the event "Walkathon"
  And then click publish event to facebook button on the sidebar panel
  Then I should be able to see the event on the Nature in the City facebook page

Scenario: failed push of newly created event on Facebook (not implemented as a transaction)
  Given I click on the event "Walkathon"
  And then click publish event to facebook button on the sidebar panel
  And there is an error
  Then I should be able to see unable to publish event to facebook right now.
