When /^I fill in event form field "(.*)" with "(.*)"$/ do |field, value|
    fill_in("event[#{field}]", :with => value)
end

When /^I fill in the required event form details$/ do
    step %q{I fill in event form field "name" with "Gardening Event"}
    step %q{I fill in event form field "contact_email" with "email@gmail.com"}
    step %q{I check "Enable Venue"}
    step %q{I fill in "autocomplete" with "400 Stanyan St San Francisco, CA 94117"}
    step %q{I accept the google maps suggested address}
    step %q{I select "3/21/2016, 4:30pm" as the "start" date and time}
    step %q{I select "3/22/2016, 4:30pm" as the "end" date and time}
    step %q{I fill in the "Description" field with "Join us for a nature walk through old town Los Angeles!"}
    step %q{I fill in the "How to find us" field with "Turn right at Sunset and Vine"}
end