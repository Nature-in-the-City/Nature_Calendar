class EventDateTime < ActiveRecord::Base
    belongs_to :event
    
    DEFAULT_DATE_FORMAT = '%b %e, %Y at %l:%M%P'
    DEFAULT_TIME_FORMAT = '%l:%M%P'
    DEFAULT_DAY_FORMAT = '%b %-d, %Y'
    
    def self.format_date(date)
        date.strftime(DEFAULT_DATE_FORMAT) if date
    end
    
    def self.format_day(date)
        date.strftime(DEFAULT_DAY_FORMAT) if date
    end
    
    def self.format_time(date)
        date.strftime(DEFAULT_TIME_FORMAT) if date
    end
    
    def day_only
        EventDateTime.format_day(start)
    end
        
    def format_start_date
        EventDateTime.format_date(start)
    end
    
    def format_end_date
        EventDateTime.format_date(self.end)
    end
    
    def start_time
        EventDateTime.format_time(self.start)
    end
    
    def end_time
        EventDateTime.format_time(self.end)
    end
    
    def at_least_1_day_long?
        (self.end - self.start) >= 1.day
    end
    
    def pick_end_time_type
        return format_end_date if at_least_1_day_long?
        self.end.strftime(DEFAULT_TIME_FORMAT)
    end
    
    def format_time
        start_time = format_start_date
        if start != self.end
            end_time = pick_end_time_type
            "#{start_time} to #{end_time}"
        else
            "#{start_time}"
        end
    end
    
    def is_past?
        DateTime.now >= self.end
    end
    
end