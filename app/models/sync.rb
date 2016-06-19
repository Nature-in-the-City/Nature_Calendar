class Sync < ActiveRecord::Base
    
  DEFAULT_DATE_FORMAT = '%b %e, %Y at %l:%M%P'
  DEFAULT_TIME_FORMAT = '%l:%M%P'

  def as_json(options={})
    {
      id: id,
      organization: organization,
      url: Rails.application.routes.url_helpers.event_path(id),
      last_sync: last_sync.iso8601,
      calendar_id: calendar_id
    }
  end
  
  def needs_updating?(latest_update)
    self.last_sync < latest_update
  end
  
  def self.pull_calendar_events(name, url)
    if url =~ /meetup.com/
      return Meetup.new.pull_events({group_urlname: name})
    elsif url =~ /gmail.com/
      return Google.new.pull_events({calendar_id: url})
    else
      raise Exception, 'Invalid URL', caller
    end
  end
  
  def self.process_updates(events, url)
    return if events.blank?
    events.each { |event| Sync.process_update(event, url) }
  end
  
  def self.process_update(event, url)
    stored_event = Event.find_by_meetup_id(event[:meetup_id])
    if stored_event.blank?
      e = Event.new(event)
      e.update_attributes(:status => 'pending', :url => url)
      return e.save!
    end
    stored_event.apply_update(event) if stored_event.needs_updating?(event[:updated])
  end
  
  def self.get_third_party_deleted(remote_events, url)
    target_events = Event.where(:url => url)
    return if target_events.blank?
    local_event_ids = target_events.inject([]) { |array, event| array << event.meetup_id }
    remote_event_ids = remote_events.inject([]) { |array, event| array << event[:meetup_id] }
    local_event_ids - remote_event_ids
  end
  
  def self.remove_third_party_deleted(remote_events, url)
    return if remote_events.nil?
    deleted_ids = Sync.get_third_party_deleted(remote_events, url)
    return if deleted_ids.blank?
    deleted_ids.each do |id|
      Event.find_by_meetup_id(id).destroy
    end
  end
  
  def self.synchronize_calendars
    Sync.find_each do |calendar|
      events = Sync.pull_calendar_events(calendar.organization.gsub(" ", "-"), calendar.url)
      Sync.remove_third_party_deleted(events, calendar.url)
      Sync.process_updates(events, calendar.url)
      calendar.update_attributes(:last_sync => DateTime.now())
      calendar.save!
    end
  end
  
  def self.sync_calendar(url)
    if Sync.where(:url => url).blank?
      begin
        name = url.split("/")[-1]
        sync = Sync.new
        sync.update_attributes(:organization => name.gsub("-", " "), :last_sync => DateTime.now(), :url => url)
        sync.save!
        events = Sync.pull_calendar_events(name, url)
        Sync.process_updates(events, url)
        return "Successfully synced '#{url}'!"
      rescue Exception => e
        return "Could not sync '#{url}': " + e.to_s
      end
    else
      return "Already synced '#{url}'!"
    end
  end
end