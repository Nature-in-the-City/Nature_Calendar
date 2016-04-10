
Given /^I see the Admin panel$/ do
    expect(page).to have_css('#admin')
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
    expect(find("li.active")).to have_content(tab)
end

Then /I should( not)? see "(.*)" before "(.*)"/ do |negated, first_item, second_item|
    rx = /#{first_item}.*#{second_item}/m
    if negated.eql? "not"
        rx = /#{second_item}.*#{first_item}/m
    end
    expect(page.body =~ rx).to be_truthy
end

Then /^the details of "(.*)" should( not)? be hidden$/ do |event, negated|
    #if negated; puts true; else; puts false; end
    event_st_num = Event.where("name = ?", event).first.st_number
    #puts event_st_num
    val = find("div.tab-pane.active")
    if negated
        #puts val.text()
        expect(val).to have_content(event_st_num)
    else
        #puts val.text()
        expect(val).not_to have_content(event_st_num)
    end
end

Given /^I(?: am)? display(?:ing)? the "(.*)" events$/ do |tab_name|
  step %{I follow "#{tab_name}"}
  name = tab_name.downcase
  expect(page).to have_css("##{name}_events.tab-pane.active")
end

Then /^I should see the following details displayed below "(.*)":  (.*)$/ do |event_name, detail_list|
  details = detail_list.split(", ")
  details.each do |det|
      expect(page).to have_content(det)
  end
end

Then /^I should( not)? see the following events: (.*)$/ do |negated, list|
  items = list.split(", ")
  found = find(:css, ".tab-pane.active")
  items.each do |item|
    if negated
      expect(found).not_to have_content(item)
    else
      expect(found).to have_content(item)
    end
  end
end

Then /^I should see "(.*)" details, including: (.*)$/ do |event, list|
  fields = list.split(", ")
  id = Event.where("name = ?", event).first.id
  div_id = "#{id}_details"
  found = find_by_id(div_id)
  fields.each do |field|
      expect(found).to have_content(field)
  end
end

When /^I display the details for "(.*)"$/ do |event|
  event_id = Event.where("name = ?", event).first.id
  show_id = "showbtn_#{event_id}"
  div_id = "#{event_id}_title"
  find("div.tab-pane.active").find_by_id(div_id).click_link(show_id)
  expect(find(:xpath, "//a[@id='#{show_id}']").text()).to have_content("Show Less")
end

Then /^I "(.*)" details on "(.*)"$/ do |link, event|
    link_options = {"Show More" => "Show Less", "Show Less" => "Show More"}
    event_id = Event.where("name = ?", event).first.id
    div_id = "#{event_id}_title"
    link_id = "showbtn_#{event_id}"
    find_by_id(div_id).find_link(link_id).click
    expect(find_by_id(div_id)).to have_content(link_options[link])
end

Given /^I display the details of "(.*)"$/ do |event_name|
   step %{I display the details for "#{event_name}"}
end

Given /^I see the "(.*)" event "(.*)"$/ do |status, event|
    event_id = Event.where("name = ?", event).first.id
    status_id = "div##{status.downcase}_events.tab-pane.active"
    div_id = "#{event_id}_title"
    expect(find(status_id).find_by_id(div_id)).to have_content(event)
end

Then /^I should see a link to "(.*)" details for "(.*)"$/  do |link_text, event|
    event_id = Event.where("name = ?", event).first.id
    div_id = "#{event_id}_title"
    link_id = "showbtn_#{event_id}"
    expect(find_by_id(div_id)).to have_link(link_text)
end

When /^I click the "(.*)" button on "(.*)"$/ do |button, event_name|
  event_id = "div##{button}_#{Event.where(name: event_name).first.id}"
  within(:css, event_id) do
    find_button(button).click
  end
  step %{I wait 5 seconds}
end

Then /^I should see the "(.*)" event "(.*)"$/ do |tab_name, event_name|
  step %{I am displaying the "#{tab_name}" events}
  step %{I should see "#{event_name}"}
end

Given /^that I see the "(.*)" event "(.*)"$/ do |tab_name, event_name|
  step %Q{I should see the "#{tab_name}" event "#{event_name}"}
end

Then /^I should( not)? see the admin panel$/ do |negated|
  pending # Write code here that turns the phrase above into concrete actions
end

Then /^I should( not)? see the sync panel$/ do |negated|
  pending # Write code here that turns the phrase above into concrete actions
end

Then /^I should( not)? see the add users button$/ do |negated|
  pending # Write code here that turns the phrase above into concrete actions
end

Given /^I click "(.*)" for "(.*)"$/ do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then /^the "(.*)" event should be deleted$/ do |event_name|
  expect(Event.exists?(:name => event_name)).to be_falsey
end

Given /^"(.*)" for "(.*)" is "(.*)"$/ do |arg1, arg2, arg3|
  pending # Write code here that turns the phrase above into concrete actions
end

When /^I change "(.*)" for "(.*)" to "(.*)"$/ do |arg1, arg2, arg3|
  pending # Write code here that turns the phrase above into concrete actions
end


Then /^"(.*)" for "(.*)" should be "(.*)"$/ do |arg1, arg2, arg3|
  pending # Write code here that turns the phrase above into concrete actions
end

Then /^the "(.*)" event status should be "(.*)"$/ do |event_name, status|
  expect(Event.where(name: event_name).first.status).to eq(status)
end

Given /^I have rejected the "(.*)" event$/ do |name|
  event_id = Event.where("name = ?", name).first.id
  Event.update(event_id, status: 'rejected')
  expect(Event.find_by_id(event_id).status).to eq('rejected')
  visit current_path
end

Then /^I should see the event "(.*)"$/ do |event_name|
  found = find("div.tab-pane.scrollable.active")
  within(:css, "div.tab-pane.scrollable.active") do
    assert_text(event_name)
  end
end

When /^I wait (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end