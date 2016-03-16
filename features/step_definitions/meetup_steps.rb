require 'httparty'
require 'cucumber/rspec/doubles'

Given /I am an authorized organizer of the group/ do
  # Here I'm using credentials to access the sandbox at Meetup
  tester = Meetup.new(group_id: '19713962', group_urlname: 'NatureWalk')
  allow(Meetup).to receive(:new).and_return(tester)
end

And /^I select "(.*)" as the "(start|end)" date and time$/ do |value, selector|
  dt  = DateTime.strptime(value, "%m/%d/%Y, %I:%M%p")
  select dt.year, :from => "event_#{selector}_1i"
  select dt.strftime("%B"), :from => "event_#{selector}_2i"
  select dt.day, :from => "event_#{selector}_3i"
  select dt.strftime("%I %p"), :from => "event_#{selector}_4i"
  select dt.min, :from => "event_#{selector}_5i"
end

# NOTE if names contain commas the I separated them with single quotation marks
And /^the Meetup events? "(.*)" should (not )?exist$/ do |event_names, negative|
  # NOTE this madness with quotation and commas is because a test name has valid commas
  # and so I cannot split by those
  event_names.include?("'") ? (char = "'") : (char = ",")
  event_names = event_names.split(char).select {|name| name =~ /\w/}
  event_names.each do |name|
    name.strip! if char == ','
    if negative
      expect(Event.find_by_name(name)).to be_nil
    else
      expect(Event.find_by_name(name)).not_to be_nil
    end
  end
end

# NOTE This works but I'm currently using the fakeweb array of responses
# to simulate failure.
Then /^break internet$/ do
  fake_data = double
  allow(fake_data).to receive(:code).and_return(404)
  allow(HTTParty).to receive(:get).and_return(fake_data)
end

# Check break internet note
Given /^I attempt to go to the "(.*)" page?$/ do |page_name|
  step %Q{break internet}
  visit path_to(page_name)
end

# Check break internet note
Given /^I try to click on the "(.*)" button$/ do |button_name|
  step %Q{break internet}
  step %Q{I click on the "Add Events" button}
end

# Check break internet note
Given /^I attempt to go to the "details" page for event: "(.*)"$/ do |name|
  step %Q{break internet}
  step %Q{I go to the "details" page for event: "#{name}"}
end

And /^I go to the "details" page for event: "(.*)"$/ do |name|
  step %Q{I am on the "details" page for "#{name}"}
end

Given /^the following events exist on Meetup:$/ do |events_table|
  # no-op
end

And /^Laura updates her RSVP by increasing her guest count to 4/ do
  # no-op
end

And /^Paul responds yes to the RSVP and sets his guest count to 3/ do
  # no-op
end

And /the "(.*)" event "(.*)" has the following RSVP list:/ do |group, event_name, list|
  # no-op
end

And /the meetup event "(.*)" is updated to the name "(.*)"/ do |name, new_name|
  # no-op
end

And /the event with id: 220680184 is renamed on Meetup to Walk the Planet/ do
  # no-op
end

And /the Meetup event Wisps & Willows, The Kilbanes, and Dara Ackerman at Viracocha! is renamed to Wisps/ do
  # no-op
end


# NOTE if names contain commas the I separated them with single quotation marks
And /^I should (not )?see the list "(.*)" containing: "(.*)"$/ do |negative, list, list_content|
  list_content.include?("'") ? (char = "'") : (char = ",")
  list_content = list_content.split(char)
  list_content.each do |entry|
    entry.strip! if char == ','
    element = find(list)
    negative ? !element.assert_no_text(entry) : element.assert_text(entry)
  end
end

And /^I should see the "(.*)" buttons$/ do |buttons|
  buttons.split(',').each do |button|
    step %Q{I should see the "#{button.strip}" button}
  end

end

And /^I (un)?check ".+" for "(.*)"$/ do |negative, items|
  items = items.split(',')
  items.each do |item|
    item.strip!
    negative ? uncheck(item) : check(item)
  end
end

And /^I searched an event by id: "(.*)"$/ do |id|
  step %Q{I fill in the "ID" field with "#{id}"}
  step %Q{I click on the "Search" button}
end

And /^I searched events by group_urlname: "(.*)"$/ do |urlname|
  step %Q{I fill in the "Group Name" field with "#{urlname}"}
  step %Q{I click on the "Search" button}
end

Given /^I already pulled the RSVP list for the event: "(.*)"/ do |name|
  step %Q{I click on "#{name}" in the calendar}
end

Given /^I already pulled from Meetup/ do
  Event.synchronize_upcoming_events
end

Given /I already pulled the event id: "(.*)"/ do |id|
  step %Q{I searched an event by id: "#{id}"}
  step %Q{I check "Select" for "event#{id}"}
  step %Q{I click on the "Add Events" button}
  # Go back to the third_party page for next step
  step %Q{I am on the "third_party" page}
end

Given /I already pulled by group_urlname: "(.*)"/ do |urlname|
  step %Q{I searched events by group_urlname: "#{urlname}"}
  step %Q{I check "Select" for "event220680184, event220804867"}
  step %Q{I click on the "Add Events" button}
  # Go back to the third_party page for next step
  step %Q{I am on the "third_party" page}
end

And /"(.*)" should (not )?exist on "(.*)"/ do |event_name, negative, platform|
  sleep(1)
  platform = platform.downcase
  if platform == 'calendar'
    event = Event.find_by_name(event_name)
    negative ? (expect(event).to be_nil) : (expect(event).not_to be_nil)
  elsif platform == 'meetup'
    meetup = Meetup.new
    event_id = 221850455
    negative ? (expect{meetup.pull_event(event_id)}.to raise_error(/not_found/)) : (expect(meetup.pull_event(event_id)).not_to be_nil)
  else
    raise Error.new
  end
end

And /the "(.*)" event should exist on "(both|neither)" platforms/ do |event_name, option|
  if option == 'neither'
    step %Q{"#{event_name}" should not exist on "Calendar"}
    step %Q{"#{event_name}" should not exist on "Meetup"}
  else
    step %Q{"#{event_name}" should exist on "Calendar"}
    step %Q{"#{event_name}" should exist on "Meetup"}
  end
end

And /the following event(?:s)? exist(?:s)? on Meetup and on the Calendar/ do |data|
  #step %Q{I am on the "Calendar" page} # fakeweb will pull an event and make it local
  Event.synchronize_upcoming_events
end

Given /the event "(.*)" is deleted on Meetup/ do |event_name|
  #meetup = Meetup.new
  #meetup.delete_event(Event.find_by_name(event_name).meetup_id)
  # no-op
end

Then /the event "(.*)" should be renamed to "(.*)" on "(.*)" platforms/ do |old_event_name, new_event_name, option|
  if option == 'both'
    step %Q{the "calendar" event "#{old_event_name}" should be renamed to "#{new_event_name}"}
    step %Q{the "meetup" event "#{old_event_name}" should be renamed to "#{new_event_name}"}
  elsif option == 'neither'
    step %Q{the "calendar" event "#{old_event_name}" should not be renamed to "#{new_event_name}"}
    step %Q{the "meetup" event "#{old_event_name}" should not be renamed to "#{new_event_name}"}
  end
end

Then /the "(.*)" event "(.*)" should (not )?be renamed to "(.*)"/ do |platform, old_event_name, negative, new_event_name|
  sleep(1)
  id = '221850455'
  if platform == 'calendar'
    expect(Event.find_by_meetup_id(id).name).to eq(negative ? old_event_name : new_event_name)
  elsif platform == 'meetup'
    expect(Meetup.new.pull_event(id)[:name]).to eq(negative ? old_event_name : new_event_name)
  end
end

Given /the event "(.*?)" is renamed on Meetup to "(.*?)"$/ do |arg1, arg2|
  # no-op
end

Then /the RSVP list for "(.*)" should include: "(.*)"/ do |event_name, name_list|
  sleep(1)
  name_list = name_list.split(',').collect {|name| name.strip}
  event = Event.find_by_name(event_name)
  rsvp_name_list = event.guests.collect {|guest| guest.first_name}
  expect(name_list).to match_array(rsvp_name_list)
end

And /the total number of participants for "(.*)", including invited guests, should be: "(.*)"/ do |event_name, total|
  sleep(1)
  event = Event.find_by_name(event_name)
  expect(total.to_i).to eq(count_event_participants(event))
end

def count_event_participants(event)
  event.registrations.inject(0) do |sum, regis|
    guest_count = regis.invited_guests
    sum + 1 + (guest_count ? guest_count : 0 )
  end
end

And /I accept the google maps suggested address/ do
  page.execute_script("$('#autocomplete').focus();")
end

And /I (attempt to )?synchronize the calendar with meetup/ do |must_fail|
  if must_fail
    expect{Event.synchronize_upcoming_events}.to raise_exception
  else
    Event.synchronize_upcoming_events
  end
end
