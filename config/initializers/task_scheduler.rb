unless Rails.env.test?
  DEBUG = true

  WebScraper.instance.fetch_page_data

  scheduler = Rufus::Scheduler.new

  ##
  # This loop will continue until the database initialization is successful
  #
  scheduler.every '1m', first: Time.now + 5 do |job|
    result = Event.initialize_calendar_db
    if result
      job.unschedule
      puts 'Completed Initial Pull.' if DEBUG
    else
      puts 'FAILED INITIAL PULL.' if DEBUG
    end
  end

  scheduler.every '5m', first: Time.now + 2 * 60  do |job|
    WebScraper.instance.fetch_page_data
    puts 'Joomla Data Fetched.' if DEBUG
  end
  
  scheduler.every '15m', first: Time.now + 2 * 60 do |job|
    Event.synchronize_past_events
    puts 'Past Events Synchronized.' if DEBUG
    Event.synchronize_upcoming_events
    puts 'Upcoming Events Synchronized.' if DEBUG
    Sync.synchronize_calendars
    puts 'Calendars Synchronized.' if DEBUG
  end
end