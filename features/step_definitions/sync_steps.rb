Given /^I see the "(.*)" panel$/ do |panel_name|
  expect(page).to have_css("div#{panel_name}")
end

When /^I press the "(.*)" button$/  do |btn|
  click_link("#{btn}")
end

Given /^the following calendars have been linked:$/  do |table|
  table.each do |item|
      #create the sync item
  end
end

Then /^I should see events from "(.*)"$/  do |calendar_name|
  events = Events.where(name: calendar_name, status: "upcoming")
  events.each do |event|
      expect(page).to have_content(event.name)
  end
end

Then /^I should see the event "(.*)".$/ do |event_name|
  expect(page).to have_content(event_name)
end

When /^I visit the "(.*)" page$/  do |page_name|
  visit path_to(page_name)
end

Then /^I should see "(.*)" in the "(.*)" panel$/ do |event, panel_name|
  with_scope(panel_name) { step %{I should see "#{event}"}}
end