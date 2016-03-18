@javascript
@meetup_pull_rsvp @successful_pull_meetup
Feature: automatically pull rsvp list from Meetup and merge to rsvp list in the calendar

  As an admin of the website
  So that I can view the RSVP of an event in one place
  I want to see a merged RSVP list on my website

  Background: The calendar has never pulled Meetup events before:

    Given the following events exist on Meetup:
      |                 name                    |    organization    |   event_id   |
      | Market Street Prototyping Festival      | Nature in the city | 219648262    |
      | Nerds on Safari: Market Street          | Nature in the city | 220706208    |
      | Volunteer at the Adah Bakalinsky Steps! | Nature in the city | 214161012    |

    And the "meetup" event "Market Street Prototyping Festival" has the following RSVP list:
      | name              | invited guests |
      | Amber Hasselbring |     0          |
      | Angela Lau        |     1          |
      | Laura             |     0          |

    And I am on the calendar page
    And I synchronize the calendar with meetup
    And the month is April 2015

  @successful_pull_rsvp
  Scenario: successfully pull the RSVP for an event
    Given I click on "Market Street Prototyping Festival" in the calendar
    #Then I should see the message "The RSVP list for this event has been updated. Angela Lau, Amber Hasselbring, Laura have joined. The total number of participants, including invited guests, so far is: 4."
    Then the RSVP list for "Market Street Prototyping Festival" should include: "Angela, Amber, Laura"
    And the total number of participants for "Market Street Prototyping Festival", including invited guests, should be: "4"

  @failed_pull_rsvp
  Scenario: fail to pull the RSVP for an event
    Given I click on "Market Street Prototyping Festival" in the calendar
    Then the RSVP list for "Market Street Prototyping Festival" should include: ""
    And the total number of participants for "Market Street Prototyping Festival", including invited guests, should be: "0"

  @repeated_unchanged_pull_rsvp
  Scenario: re-pull the RSVP for an event
    Given I already pulled the RSVP list for the event: "Market Street Prototyping Festival"
    And I click on "Market Street Prototyping Festival" in the calendar
    Then the RSVP list for "Market Street Prototyping Festival" should include: "Angela, Amber, Laura"
    And the total number of participants for "Market Street Prototyping Festival", including invited guests, should be: "4"

  @repeated_changed_pull_rsvp
  Scenario: re-pull the updated RSVP for an event
    Given I already pulled the RSVP list for the event: "Market Street Prototyping Festival"
    And Laura updates her RSVP by increasing her guest count to 4
    And Paul responds yes to the RSVP and sets his guest count to 3
    And I click on "Market Street Prototyping Festival" in the calendar
    #Then I should see the message "The RSVP list for this event has been updated. Laura , Paul have joined. The total number of participants, including invited guests, so far is: 11."
    Then the RSVP list for "Market Street Prototyping Festival" should include: "Angela, Amber, Laura, Paul"
    And the total number of participants for "Market Street Prototyping Festival", including invited guests, should be: "11"




