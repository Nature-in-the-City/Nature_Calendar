class Google
  include HTTParty
    
  attr_reader :default_calendar_id, :default_auth
    
  BASE_URL = 'https://www.googleapis.com/calendar/v3/calendars/'
    
  def default_calendar_id=(calendar_id='')
    @default_calendar_id = calendar_id
  end

  def initialize(options={})
    self.default_calendar_id = options[:calendar_id]
  end
    
  def pull_events(options={})
    data = HTTParty.get("#{BASE_URL}/#{@default_calendar_id}/events")
    Google.process_result(data[:items], lambda {|arg| Google.parse_event(arg)}, ['200'])
  end
    
  def self.process_result(result, handler, success_codes)
    success = (success_codes.include?(result.code.to_s))
    return success if handler.nil?
    if success
      parse_data(result, handler)
    else
      message = parse_error(result)
      raise message
    end
  end
    
  def self.parse_event(data)
    {meetup_id: data['id'],
     name: data['summary'],
     description: data['description'] || '',
     organization: data['organizer']['displayName'] || '',
     url: data['htmlLink'] || '',
     how_to_find_us: data['how_to_find_us'] || '',
     status: data['status'] || ''}.merge(parse_dates(data)).merge(parse_venue(data))
  end
  
  def self.parse_error(result)
    data = result.parsed_response
    message = "#{data['code']} #{data['message']} #{data['problem']} #{data['details']}"
    errors = data['errors'] || [data]
    errors[0].each do |k, v|
      message += " #{k} : #{v} "
    end
    message
  end
end