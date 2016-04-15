class Meetup
  include HTTParty

  attr_reader :default_group_id, :default_group_urlname, :default_auth, :default_group_name

  BASE_URL = 'https://api.meetup.com'
  # API_KEY = ENV['MEETUP_API']
  API_KEY = '5f7f6bf22797a794a2531b37207e79'

  # NATURE IN THE CITY DATA

  #GROUP_ID = '8870202'
  #GROUP_URLNAME = 'Nature-in-the-City'
  #GROUP_NAME = 'Nature in the City'

  # TESTING DATA

  GROUP_ID = '19713962'
  GROUP_URLNAME = 'NatureWalk'
  GROUP_NAME = 'Berkeley Nature Walk'


  def default_group_name=(name='')
    @default_group_name = name.blank? ? GROUP_NAME : name
  end

  def default_group_urlname=(urlname='')
    @default_group_urlname = urlname.blank? ? GROUP_URLNAME : urlname
  end

  def default_group_id=(id='')
    @default_group_id = id.blank? ? GROUP_ID : id
  end

  def default_auth=(params)
    token, key = params
    @default_auth = token ? {access_token: token} : {key: key||API_KEY}
  end

  def initialize(options={})
    # Needs either a key, or a token.
    self.default_auth = options[:access_token], options[:key]
    self.default_group_urlname = options[:group_urlname]
    self.default_group_name = options[:organization]
    self.default_group_id = options[:group_id]
  end

  def edit_event(args)
    options = {}
    options[:body] = get_event_data(args[:event], args[:id]).merge(default_auth)
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event/#{args[:id]}", options)
    Meetup.process_result(data, lambda {|arg| Meetup.parse_event(arg)}, ['200'])
  end

  def delete_event(id)
    data = HTTParty.delete("#{BASE_URL}/2/event/#{id}?#{Meetup.options_string(default_auth)}")
    Meetup.process_result(data, nil, ['200'])
  end

  # ASK ABOUT ANNOUNCING EVENTS... If necessary it can be done here automatically...or with edit_event
  def push_event(event)
    options = {}
    options[:body] = {group_id: default_group_id, group_urlname: default_group_urlname}.merge(default_auth)
    options[:body].merge!(get_event_data(event))
    #options[:body].merge!(announce:'true')
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event", options)
    Meetup.process_result(data, lambda {|arg| Meetup.parse_event(arg)}, ['201'])
  end

  def pull_event(id)
    data = HTTParty.get("#{BASE_URL}/2/event/#{id}?#{Meetup.options_string(default_auth)}")
    Meetup.process_result(data, lambda {|arg| Meetup.parse_event(arg)}, ['200'])
  end

  def pull_events(options={})
    if options[:event_id].nil? && options[:group_urlname].nil?
      options.merge!(group_id: default_group_id) # if user gave no options, then pull by default group id
    end
    options.merge!(default_auth)
    data = HTTParty.get("#{BASE_URL}/2/events?#{Meetup.options_string(options)}")
    Meetup.process_result(data, lambda {|arg| Meetup.parse_event(arg)}, ['200'])
  end

  def pull_rsvps(options={})
    options.merge!(default_auth)
    options.merge!({rsvp: 'yes'})
    data = HTTParty.get("#{BASE_URL}/2/rsvps?#{Meetup.options_string(options)}")
    Meetup.process_result(data, lambda {|arg| Meetup.parse_rsvp(arg)}, ['200'])
  end

  # Used to get venue ids when we need to push an event to Meetup.
  # Can search by any of: event_id, group_id, group_urlname, venue_id
  # We'll choose to use the event_id

  def get_venues(options={})
    options = options.merge(default_auth)
    data = HTTParty.get("#{BASE_URL}/2/venues?#{Meetup.options_string(options)}")
    Meetup.process_result(data, lambda {|arg| arg}, ['200'])
  end

  # Posts a venue to Meetup
  def create_venue(event)
    options = {}
    options[:body] = Venue.get_event_venue_data(event).merge(default_auth)
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/#{default_group_urlname}/venues", options)
    Meetup.process_result(data, lambda {|arg| data}, ['201', '409'])
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

  def self.parse_error(result)
    data = result.parsed_response
    message = "#{data['code']} #{data['message']} #{data['problem']} #{data['details']}"
    errors = data['errors'] || [data]
    errors[0].each do |k, v|
      message += " #{k} : #{v} "
    end
    message
  end

  def self.parse_data(result, handler)
    data = result.parsed_response
    elements = data['results']
    if elements
      elements.map {|element| handler.call(element)}
    else
      handler.call(data)
    end
  end

  def self.parse_event(data)
    {meetup_id: data['id'],
     name: data['name'],
     description: data['description'] || '',
     organization: data['group']['name'] || '',
     url: data['event_url'] || '',
     how_to_find_us: data['how_to_find_us'] || '',
     status: data['status'] || ''}.merge(parse_dates(data)).merge(parse_venue(data))
  end

  def self.parse_dates(data)
    time = data['time']
    duration = data['duration']
    {start: build_date(time),
    end: build_date(time ? time + (duration ? duration : 0) : nil),
    updated: build_date(data['updated'])}
  end

  def self.parse_venue(data)
    if data && data = data['venue']
      st_num, st_name = Meetup.parse_address(data['address_1'])
      {venue_name: data['name'] || '',
       st_number: st_num || '',
       st_name: st_name || '',
       city: data['city'] || '',
       zip: data['zip'] || '',
       state: data['state'] || '',
       country: data['country'] || ''}
    else
      {}
    end
  end

  def self.parse_address(data)
    data =~ /^(\d+)\b/
    num = $1 || ''
    num.present? ? (name = data[num.size..data.size].strip) : (name = data)
    [num, name]
  end

  def get_event_data(event, id=nil)
    start = event['start']
    stop = event['end']
    duration = (stop && start) ? stop - start : nil
    {name: event['name'],
     description: event['description'],
     venue_id: Venue.get_meetup_venue_id(event, id),
     time: Meetup.get_milliseconds(start),
     duration: Meetup.get_milliseconds(duration),
     how_to_find_us: event['how_to_find_us']}.compact
  end

  def self.build_date(time)
    return if time.nil?
    millis_per_second = 1000
    Time.at(time / millis_per_second).to_datetime
  end

  def self.parse_rsvp(data)
    member = data['member']
    {event_id: data['event']['id'],
     meetup_id: member['member_id'],
     meetup_name: member['name'],
     invited_guests: data['guests'],
     updated: build_date(data['mtime'])}
  end

  def self.options_string(options)
    options.map { |key,value| "#{key}=#{value}" }.join("&")
  end

  def self.get_milliseconds(date)
    return if date.nil?
    date.to_i * 1000
  end
end
