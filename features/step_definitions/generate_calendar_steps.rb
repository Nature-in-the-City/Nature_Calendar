Capybara.javascript_driver = :webkit

Given /^(?:|I )am on the calendar page$/ do
  visit '/calendar'
end

And /^the month is ([A-Za-z]*) (\d+)$/ do |month, year|
  @date = month + " " + year
  page.execute_script("$('#calendar').fullCalendar('gotoDate', new Date(2016, #{to_num(month)}))")
end

Then /^the month should be ([A-Za-z]*) (\d+)$/ do |month, year|
  mo = page.execute_script("$('#calendar').fullCalendar('getDate').month()")
  month == number_to_month( mo )

  yr = page.execute_script("$('#calendar').fullCalendar('getDate').year()")
  year == yr
end

When /^(?:|I )click on the calendar's (.*) arrow$/ do |link|
  case link
  when "next"
    page.execute_script("$('#calendar').fullCalendar('next')")
  when "previous"
    page.execute_script("$('#calendar').fullCalendar('prev')")
  end
end

And /^the (?:first|last) day should be (.*)$/ do |day|
  day_of_week = page.execute_script("$('#calendar').fullCalendar('getDate').day()")
  day == number_to_day_of_week( day_of_week )
end

def number_to_month(num)
  case num
  when 0 then "January"
  when 1 then "February"
  when 2 then "March"
  when 3 then "April"
  when 4 then "May"
  when 5 then "June"
  when 6 then "July"
  when 7 then "August"
  when 8 then "September"
  when 9 then "October"
  when 10 then "November"
  when 11 then "December"
  end
end

def number_to_day_of_week(num)
  case num
  when 0 then "Sunday"
  when 1 then "Monday"
  when 2 then "Tuesday"
  when 3 then "Wednesday"
  when 4 then "Thursday"
  when 5 then "Friday"
  when 6 then "Saturday"
  end
end

def to_num(str)
  case str
  when ("January" || "Sunday") then 0
  when ("February" || "Monday") then 1
  when ("March" || "Tuesday") then 2
  when ("April" || "Wednesday") then 3
  when ("May" || "Thursday") then 4
  when ("June" || "Friday") then 5
  when ("July" || "Saturday") then 6
  when "August" then 7
  when "September" then 8
  when "October" then 9
  when "November" then 10
  when "December" then 11
  end
end
