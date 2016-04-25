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
    
    @all = Event.order(:start)
    @curr = @all.upcoming
    
    @past = @all.past.approved
    
    @pending = Event.filtered(@curr.pending, @filter)
    @upcoming = Event.filtered(@curr.approved, @filter)
    @rejected = Event.filtered(@curr.rejected, @filter)
    
    @tags = ["Free", "Family-friendly", "Play", "Volunteer", "Hike", "Learn"]
    @event_relations = {"Upcoming" => @upcoming, "Pending" => @pending,
                        "Rejected" => @rejected, "Past" => @past}
    
    @tabs = %w(Upcoming Pending Rejected Past)
    @pending_count = @pending.count
    
    @head, @body = WebScraper.instance.page_data
    @calendars = Sync.find_each
  end
end
