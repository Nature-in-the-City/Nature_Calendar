class Event < ActiveRecord::Base
  has_many :registrations
  has_many :guests, through: :registrations

  has_attached_file :image,
                    styles: {original: "300x200"},
                    url: "/assets/:id/:style/:basename.:extension",
                    path: "public/assets/:id/:style/:basename.:extension",
                    default_url: "/assets/missing.png"

  do_not_validate_attachment_file_type :image

  DEFAULT_DATE_FORMAT = '%b %e, %Y at %l:%M%P'
  DEFAULT_TIME_FORMAT = '%l:%M%P'
  
  scope :approved, -> { where(status: "approved") }
  scope :family_friendly, -> { where(family_friendly: true) }
  scope :free, -> { where(free: true) }
  scope :hike, -> { where(category: "hike") }
  scope :play, -> { where(category: "play") }
  scope :learn, -> { where(category: "learn") }
  scope :volunteer, -> { where(category: "volunteer") }
  scope :past, -> { where(%q{"end" < ?}, DateTime.now) }
  scope :upcoming, -> { where(%q{"end" > ?}, DateTime.now) }

  def as_json(options={})
    {
      id: id,
      third_party: is_third_party?,
      category: self.category,
      title: name,
      start: start.iso8601,
      url: Rails.application.routes.url_helpers.event_path(id)
    }
  end

  def is_new?
    Event.find_by_meetup_id(meetup_id).nil?
  end

  def needs_updating?(latest_update)
    updated < latest_update
  end

  def is_past?
    DateTime.now >= self.end
  end
  
  def tag_string
    tag_options = %w(family_friendly free)
    event_tags = []
    tag_options.each do |tag|
      event_tags.push(Event.format_tag(tag)) if self[tag]
    end
    event_tags.push(Event.format_tag(self.category))
    formatted = event_tags.join(", ")
    return ((formatted.length > 0)? formatted : "None")
  end
  
  def self.format_tag a_tag
    split_capitalize = a_tag.split("_").map &:capitalize
    to_join = split_capitalize.reject{ |s| s.empty? }
    return to_join.join("-")
  end
  
  def self.get_remote_events(options={})
    meetup_events = Meetup.new.pull_events(options)
    if meetup_events.respond_to?(:each)
      meetup_events.each_with_object([]) {|event, candidate_events| candidate_events << Event.new(event)}
    end
  end

  def self.get_remote_meetup_events(options={})
    meetup_events = Meetup.new.pull_events({group_urlname: options[:group_urlname]})
    if meetup_events.respond_to?(:each)
      meetup_events.each do |event| 
        e = Event.create(event)
        e.update_attributes(:status => 'pending', :url => options[:url])
        e.save!
        end
    end
  end
  
  def self.get_remote_google_events(options={})
    google_events = Google.new.pull_events(options)
    if google_events.respond_to?(:each)
      google_events.each do |event| 
        e = Event.create(event)
        e.update_attributes(:status => 'pending', :url => options[:url])
        e.save!
      end
    end
  end

  def self.process_remote_events(events)
    return if events.blank?
    events.each { |event| Event.process_event(event) }
  end

  def self.process_event(event)
    stored_event = Event.find_by_meetup_id(event[:meetup_id])
    return event.save if stored_event.nil?
    stored_event.apply_update(event) if stored_event.needs_updating?(event[:updated])
  end

  def self.remove_remotely_deleted_events(remote_events)
    return if remote_events.nil?
    remotely_deleted_ids = Event.get_remotely_deleted_ids(remote_events)
    remotely_deleted_ids.each { |id| Event.find_by_meetup_id(id).destroy }
  end

  # This only applies to present and upcoming events. Past events cannot be deleted
  def self.get_remotely_deleted_ids(remote_events)
    target_events = Event.where("start >= ?", DateTime.now)
    local_event_ids = target_events.inject([]) { |array, event| array << event.meetup_id }
    remote_event_ids = remote_events.inject([]) { |array, event| array << event.meetup_id }
    local_event_ids - remote_event_ids
  end

  def self.get_upcoming_events
    Event.get_remote_events({ status: 'upcoming' })
  end

  def self.get_past_events(from=nil, to=nil)
    Event.get_remote_events({ status: 'past' }.merge Event.date_range(from, to))
  end

  def self.get_upcoming_third_party_events
    ids = Event.get_stored_upcoming_third_party_ids
    if ids.size > 0
      options = { event_id: ids.join(',') }
      events = Event.get_remote_events({ status: 'upcoming' }.merge options)
      return events if events
    end
    []
  end
  
  # get all of the events with specified status
  def self.get_events_by_status(some_status, filter)
    if filter and not filter.empty?
      return Event.where("status = ? AND #{filter} = ?", some_status, true)
    end
    Event.where(status: some_status)
  end
  
  def self.get_past_third_party_events(from=nil, to=nil)
    ids = Event.get_stored_past_third_party_ids
    if ids.size > 0
      options = { event_id: ids.join(',') }
      range = Event.date_range(from, to)
      events = Event.get_remote_events(({ status: 'past' }.merge options).merge range)
      return events if events
    end
    []
  end

  def self.date_range(from=nil, to=nil)
    (from || to) ? {time: "#{from},#{to}"} : {}
  end

  def self.store_third_party_events(ids)
    options = ids.respond_to?(:join) ? { event_id: ids.join(',') } : {}
    Event.process_remote_events(Event.get_remote_events(options))
  end

  def self.initialize_calendar_db
    upcoming_events = Event.get_upcoming_events
    past_events = Event.get_past_events
    remote_events = upcoming_events && past_events ? upcoming_events + past_events : nil
    process_remote_events(remote_events)
  end

  def self.synchronize_past_events
    group_events = Event.get_past_events('-1d', '')
    third_party_events = Event.get_past_third_party_events('-1d', '')
    remote_events = group_events && third_party_events ? group_events + third_party_events : nil
    process_remote_events(remote_events)
  end

  def self.synchronize_upcoming_events
    group_events = Event.get_upcoming_events
    third_party_events = Event.get_upcoming_third_party_events
    remote_events = group_events && third_party_events ? group_events + third_party_events : nil
    Event.remove_remotely_deleted_events(remote_events)
    process_remote_events(remote_events)
  end

  def self.get_default_group_name
    Meetup::GROUP_NAME
  end

  def self.internal_third_party_group_name
    'affiliate'
  end

  def self.get_stored_upcoming_third_party_ids
    ids = Event.where("start >= ?", DateTime.now).each_with_object([]) { |event, ids| ids << event.meetup_id if event.is_third_party? }
    ids[0...200]    # Meetup limits the number of ids you can send to them to 200
  end

  ##
  # Only get third party events which ended the day before
  #
  def self.get_stored_past_third_party_ids
    ids = Event.where(end: (DateTime.now - 1...DateTime.now)).each_with_object([]) { |event, ids| ids << event.meetup_id if event.is_third_party? }
    ids[0...200]    # Meetup limits the number of ids you can send to them to 200
  end

  def is_third_party?
    is_external_third_party? || (organization != Event.get_default_group_name)
  end

  ##
  # NOTE: Because of the many events in the db where the organization was erroneously set to nil, here I am going to
  # consider any event with nil organization as external third party.
  # FROM 11-28-2015 THIS WILL NOT BE AN ISSUE ANYMORE since there will not be a nil organization name anymore
  #
  def is_external_third_party?
    organization != Event.get_default_group_name && organization != Event.internal_third_party_group_name || organization.nil?
  end

  def apply_update(new_event)
    new_pairs = new_event.attributes
    new_pairs.delete 'organization'      # We don't want to update the db with organization names coming from meetup
    modified_pairs = new_pairs.select { |key, value| value && value != self[key] }
    update_attributes(modified_pairs)
  end

  def get_remote_rsvps
    Meetup.new.pull_rsvps(event_id: meetup_id)
  end

  def merge_meetup_rsvps
    rsvps = get_remote_rsvps
    return if rsvps.blank?
    rsvps.each do |rsvp|
      guest = Guest.find_by_meetup_rsvp(rsvp) || Guest.create_by_meetup_rsvp(rsvp)
      process_rsvp(rsvp, guest.id)
    end
  end

  def process_rsvp(rsvp, guest_id)
    registration = Registration.find_by({event_id: id, guest_id: guest_id})
    guests = rsvp[:invited_guests]
    updated = rsvp[:updated]
    return  Registration.create!(event_id: id, guest_id: guest_id, invited_guests: guests, updated: updated) if registration.nil?
    registration.update_attributes!(invited_guests: guests, updated: updated) if registration.needs_updating?(updated)
  end

  def self.get_requested_ids(data)
    data.keys.select { |key| key =~ /^event.+$/ } if data.respond_to? :keys
  end

  def self.cleanup_ids(ids)
    clean_ids = []
    ids.each { |id| clean_ids << id.gsub("event", "") } if ids.respond_to? :each
    clean_ids
  end

  def self.get_event_ids(args)
    Event.cleanup_ids(Event.get_requested_ids(args))
  end
  
  def street_address
    street_name = (st_name ? (st_name.split(" ").map &:capitalize) : nil)
    self.st_name = street_name.reject{ |str| str.empty? }.join(" ") if street_name
    return "#{self.st_number} #{self.st_name}" if st_number && street_name
    return nil
  end
    
  def city_state_zip
    city_name = (self.city ? (self.city.split(" ").map &:capitalize) : nil)
    self.city = city_name.reject{ |str| str.empty? }.join(" ") if city_name
    return "#{self.city}, #{self.state} #{self.zip}" if city && zip
    return "#{self.city}, #{self.state}" if city
    return "#{self.zip}" if zip
    return nil
  end
  
  def location
      return "#{self.street_address}, #{self.city_state_zip}" if self.street_address && self.city_state_zip
      return "#{self.city_state_zip}, #{self.country}" if self.city_state_zip
      return "Unavailable"
  end

  ##
  # Used only during event creation. It basically gets a few selected fields
  # from the newly created event we got back from meetup and it sticks them
  # into the event for database storage purposes
  #
  def update_meetup_fields(event)
    keys = [:meetup_id, :updated, :url, :status]
    keys.each { |key| self[key] = event[key] }
  end

  def format_start_date
    Event.format_date(start)
  end

  def format_end_date
    Event.format_date(self.end)
  end

  def self.format_date(date)
    date.strftime(DEFAULT_DATE_FORMAT) if date
  end

  def at_least_1_day_long?
    (self.end - start) >= 1.day
  end

  def pick_end_time_type
    return format_end_date if at_least_1_day_long?
    self.end.strftime(DEFAULT_TIME_FORMAT)
  end

  def format_time
    start_time = format_start_date
    if self.end && start != self.end
      end_time = pick_end_time_type
      "#{start_time} to #{end_time}"
    else
      "#{start_time}"
    end
  end
  

end
