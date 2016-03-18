
Given /^I see the Admin panel$/ do
    expect(page).to have_css('#events_box')
end

Given /^I see the "(.*?)" status tab$/ do |tab|
    expect(page).to have_content(tab)
end

Given /^I see the following status tabs: (.*?)$/ do |tabs|
    t = tabs.split(", ")
    t.map &:downcase
    t.each do |tab|
        step "I see the #{tab} status tab"
    end
end

Given /the date is "(.*?)"$/ do |date|
    ENV["T_DATE"] = DateTime.strptime(date, '%m/%d/%Y %I:%M:%S %p').to_s
end

Then /I press the "(.*?)" tab$/ do |tab|
    click_link(tab)
end

Then /^I should (?:|only )see (.*) events$/ do |stat|
    expected_status = stat.split(", ")
    if expected_status.length > 1
        expected_status.each do |status|
            expect(page).to have_content(status)
        end
    else
        expect(page).to have_content(expected_status[0])
    end
    options = %w(pending rejected past upcoming)
    options.each do |opt|
        if !(expected_status.include? opt)
            expect(page).to have_content(opt)
        end
    end
end

Then /^(?:|I )should( not)? see events with dates (.*) now$/ do |negation, order|
    if order.eql? 'before'
        puts 'before'
    else
        puts 'after'
    end
end



Then /I should( not)? see "(.*)" before "(.*)"/ do |negated, first_item, second_item|
    rx = /#{first_item}.*#{second_item}/m
    if negated.eql? "not"
        rx = /#{second_item}.*#{first_item}/m
    end
    expect(page.body =~ rx).to be_truthy
end

Given /^I am displaying "(.*)" events$/  do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When /^I press the "(.*)" on "(.*)"$/ do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then /^the details of "(.*)" should( not)? be hidden$/ do |event, negated|
    val = find("#{arg1}").visible?
    if negated
        expect(val).to be_falsy
    else
      expect(val).to be_truthy
  end
end

Given /^I display the details of "(.*)"$/ do |arg1|
  find("#{arg1}").visible?
end

Given /^I am displaying the "(.*)" events$/ do |arg1|
  expect(page).to have_css("##{arg1}[active]")
end

Then /^I should see the following details displayed below "(.*)":  (.*)$/ do |event_name, detail_list|
  details = detail_list.split(", ")
  details.each do |det|
      expect(page).to have_content(det)
  end
end

Then /^I should( not)? see the following events: ("(.*)"(,)?)+$/ do |arg1, arg2, arg3|
  expect(page).not_to have_content(arg1)
  expect(page).not_to have_content(arg1)
  expect(page).not_to have_content(arg1)
end

Then(/^I should see the following details displayed below "([^"]*)": "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)"$/) do |arg1, arg2, arg3, arg4, arg5, arg6, arg7|
  pending # Write code here that turns the phrase above into concrete actions
end