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

  def needs_syncing?(latest_sync)
    last_sync < latest_sync
  end
  
  def self.get_events(options={})
  end
  
end