class CalendarsController < ApplicationController

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to protocol: 'http://', status: :moved_permanently
    end
  end

  def show
    if params[:event] then
      @filter = params[:event][:filter]
    end
    @tabs = %w(Upcoming Pending Rejected Past)
    @pending_count = Event.get_pending_events.count
    @pending = Event.get_pending_events.order(:start)
    @upcoming = Event.where(status: 'approved').order(:start)
    @past = Event.where(status: 'past', status: 'upcoming').order(start: :desc)
    @rejected = Event.get_rejected_events.order(:start)
    @event_relations = {"Upcoming" => @upcoming, "Pending" => @pending,
                        "Rejected" => @rejected, "Past" => @past}
    @head, @body = WebScraper.instance.page_data
    @calendars = Sync.all
  end
end
