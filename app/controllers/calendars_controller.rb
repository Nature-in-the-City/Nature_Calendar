class CalendarsController < ApplicationController

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to protocol: 'http://', status: :moved_permanently
    end
  end

  def show
    @filter = nil
    if params[:event] then
      @filter = params[:event][:filter]
    end
    
    @pending = Event.get_events_by_status('pending', @filter).upcoming.order(:start)
    @upcoming = Event.get_events_by_status('approved', @filter).upcoming.order(:start)
    @past = Event.past
    @rejected = Event.get_events_by_status('rejected', @filter).upcoming.order(:start)
    
    @event_relations = {"Upcoming" => @upcoming, "Pending" => @pending,
                        "Rejected" => @rejected, "Past" => @past}
    
    @tabs = %w(Upcoming Pending Rejected Past)
    @pending_count = @pending.count
    
    @head, @body = WebScraper.instance.page_data
    @calendars = Sync.all
  end
end
