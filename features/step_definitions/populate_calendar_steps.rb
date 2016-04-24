Capybara.javascript_driver = :webkit

Then /^I(?:| should) see the event "(.*)" on the "(.*)"$/ do |title, date|
  @date = date.to_datetime.iso8601.to_s
  @title = title
  page.execute_script("$('#calendar').fullCalendar( 'gotoDate', '#{@date}' )")
  expect(page).to have_content(@title)
end

When /^I click the event$/ do
  link = page.evaluate_script("var events = $('#calendar').fullCalendar( 'clientEvents' );
                               var returnVal = '';
                               for(var i = 0; i < events.length; i++) {
                                 if( events[i].start.toISOString().substr(0,10) == moment('#{@date}').toISOString().substr(0,10) ) {
                                   if( events[i].title == '#{@title}' ) {
                                     returnVal = returnVal + events[i].url;
                                   }
                                 }
                               }
                               returnVal;")
  visit link
end

Then /^I should be on its details page$/ do
  step %Q(I should be on the "details" page for "#{@title}")
end