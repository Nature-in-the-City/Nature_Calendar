Capybara.javascript_driver = :webkit

When /^I fill in event form field "(.*)" with "(.*)"$/ do |field, value|
    fill_in("event[#{field}]", :with => value)
end

When /^I fill in the required event form details for event "(.*)" on "(.*)" and submit$/ do |name, date|
    step %Q{I fill in event form field "name" with "#{name}"}
    step %q{I fill in event form field "contact_email" with "email@gmail.com"}
    step %q{I check "Enable Venue"}
    step %Q{I fill in event form field "venue_name" with "SF Park"}
    step %q{I fill in "autocomplete" with "Golden Gate Park"}
    step %q{I accept the google maps suggested address}
    step %Q{I select "#{date}, 4:30pm" as the "start" date and time}
    step %Q{I select "#{date}, 6:30pm" as the "end" date and time}
    step %q{I fill in the "Description" field with "Join us for a nature walk through Golden Gate Park!"}
    step %q{I fill in event form field "how_to_find_us" with "Come to the park!"}
    step %q{I press "submit_suggest_event"}
end