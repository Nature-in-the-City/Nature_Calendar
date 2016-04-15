Given /^the following events exist(?: on the calendar)*:$/ do |events_table|
  events_table.hashes.each do |event|
    Event.create!(event)
  end
end

Given /I should see the following fields: "(.*)"$/ do |fields|
  fields.split(',').each do |field|
    step %Q{I should see the "#{field.strip}" on the page}
  end
end

When /^I add new events:$/ do |events_table|
  events_table.hashes.each do |event|
    Event.create!(event)
  end
end

Then /I should( not)? see the "(.*)" button$/ do |negated, button_name|
  if negated
    expect(page).not_to have_button(button_name)
  else
    expect(page).to have_button(button_name)
  end
end

Then /I should see(?:| the) "(.*)" on the page$/ do |content|
  expect(page).to have_content(content)
end

And /^I fill in the "(.*)" field with "(.*)"$/ do |field, value|
  if (field != 'Description')
    field = find_field(field)
    field.set value
  else
    js = "tinyMCE.get('event_description').setContent('#{value}')"
    page.execute_script(js)
  end
end

And /^I select "([^"]*)" as the date and time$/ do |value|
  dt = DateTime.strptime(value, "%m/%d/%Y, %H:%M%p")
  select dt.year, from: 'event_start_1i'
  select dt.strftime("%B"), from: 'event_start_2i'
  select dt.day, from: 'event_start_3i'
  select dt.hour, from: 'event_start_4i'
  select dt.min, from: 'event_start_5i'
end

Then /I should (not )?see the "(.*)" link$/ do |negative, link|
  if negative
    expect(page).to_not have_link(link)
  else
    expect(page).to have_link(link)
  end
end

Then /^I should see "(.*)" as the "(.*)"$/ do |value, field|
  field = find_by_id(field.downcase)
  expect(field).to have_content(value)
end

Then /^I should see the (javascript )?(?:flash message |message )?"([^"]*)"$/ do |type, message|
  if type == 'javascript '
    sleep 1
    expect(page.driver.browser.alert_messages[0]).to include(message)
  else
    expect(page).to have_content(message)
  end
end

Then /the "(.*)" field should be populated with "(.*)"$/ do |field, value|
  expect(field_labeled(field).value).to match(/#{value}/)
end

Then /the "(.*)" time field should be populated with "(.*)"$/ do |field, value|
  field = field.downcase
  date_time = DateTime.strptime(value, "%m/%d/%Y, %H:%M%p")
  expect(page).to have_field("event_#{field}_1i", with: date_time.year)
  expect(page).to have_field("event_#{field}_2i", with: date_time.month)
  expect(page).to have_field("event_#{field}_3i", with: date_time.day)
  expect(page).to have_field("event_#{field}_4i", with: date_time.hour)
  expect(page).to have_field("event_#{field}_5i", with: date_time.min)
end

Then /the "(.*)" field should not be populated$/ do |field|
  expect(field.labeled(field).value).to eq("")
end

Given /^I am on the "(.*)" page(?: for "(.*)")?$/ do |page_name, event_name|
  if event_name
    visit path_to_event(page_name, event_name)
  else
    visit path_to(page_name)
  end
end

When /^I (attempt to )?click on the "(.*)" (link|button)$/ do |must_fail, element_name, element_type|
  if element_type == 'link'
    must_fail ? (expect{click_link(element_name)}.to raise_exception) : click_link(element_name)
  elsif element_type == 'button'
    must_fail ? (expect{click_button(element_name)}.to raise_exception) : click_button(element_name)

  end
end

Then /^I should be on the "(.*)" page(?: for "(.*)")?$/ do |page_name, event_name|
  current_path = URI.parse(current_url).path
  if event_name
    expect(path_to_event(page_name, event_name)).to eq(current_path)
  else
    expect(path_to(page_name)).to eq(current_path)
  end
end

Given(/^"(.*)" exists$/) do |arg|
  expect(page).to have_content(arg)
end

def path_to_event(page_name, event_name)
  page_name = page_name.downcase
  path_to("the #{page_name} page for #{event_name}")
end

Given(/^I know event "([^"]*)": "([^"]*)"$/) do |arg1, arg2|
  puts 'features/step_definitions/event_steps.rb'
end

Then(/^I should have "([^"]*)": "([^"]*)"$/) do |arg1, arg2|
  puts 'features/step_definitions/event_steps.rb'
end

Then(/^the "([^"]*)" event should exits on "([^"]*)" platforms$/) do |arg1, arg2|
  puts 'features/step_definitions/event_steps.rb'
end

Then(/^the event should exist on "([^"]*)" platforms$/) do |arg1|
  puts 'features/step_definitions/event_steps.rb'
end

Given(/^I create a new event called "([^"]*)"$/) do |arg1|
  puts 'features/step_definitions/event_steps.rb'
end

Given(/^the event takes place on "([^"]*)"$/) do |arg1|
  puts 'features/step_definitions/event_steps.rb'
end

Given(/^I click on the event "([^"]*)"$/) do |arg1|
  puts 'features/step_definitions/event_steps.rb'
end

Given(/^the event "([^"]*)" should be colored "([^"]*)"$/) do |arg1, arg2|
  puts 'features/step_definitions/event_steps.rb'
end

Given /^the following events with category (?:exist:|exist on the calendar:)$/ do |events_table|
  puts 'features/step_definitions/event_steps.rb'
  pending
end