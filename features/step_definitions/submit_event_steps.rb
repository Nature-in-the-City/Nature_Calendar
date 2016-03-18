When /^I fill in event form field "(.*)" with "(.*)"$/ do |field, value|
    fill_in("event[#{field}]", :with => value)
end

When /^I fill in the required event form details$/ do
    step %w{I fill in event form field "name" with "Gardening Event"}
    step %w{I fill in event form field "contact_email" with "email@gmail.com"}
    step %w{I check "Enable Venue"}
    step %w{I fill in "autocomplete" with "400 Stanyan St San Francisco, CA 94117"}
end