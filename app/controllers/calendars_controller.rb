class CalendarsController < ApplicationController

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to protocol: 'http://', status: :moved_permanently
    end
  end

  def show
    @tabs = %w(Upcoming Pending Rejected Past)
    Event.update_event_statuses
    @pending = Event.joins(:event_date_time).where("status = 'pending'").order('start')
    puts @pending
    @pending_count = @pending.count
    @upcoming = Event.joins(:event_date_time).where("status = 'approved'").order('start')
    @past = Event.joins(:event_date_time).where("status ='past'").order('start DESC')
    @rejected = Event.joins(:event_date_time).where("status ='rejected'").order('start')
    @event_relations = {"Upcoming" => @upcoming, "Pending" => @pending,
    "Rejected" => @rejected, "Past" => @past}
    @head, @body = WebScraper.instance.page_data
  end
end
