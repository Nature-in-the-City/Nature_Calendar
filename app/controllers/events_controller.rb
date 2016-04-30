class EventsController < ApplicationController
  #before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :third_party]

  before_filter :check_for_cancel, only: [:create, :update, :third_party]
  
  def check_for_cancel
    render 'default', format: :js  if params[:cancel]
  end

  def index
    @start_date = params[:start]
    @end_date = params[:end]
    @events = (@start_date && @end_date) ? Event.approved.where(start: @start_date.to_datetime..@end_date.to_datetime) : Event.approved

    @filter = params[:filter]
    case @filter
    when 'family_friendly'
      @events = @events.family_friendly
    when 'free'
      @events = @events.free
    end

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
    begin
      @event = Event.find params[:id]
      @time_period = @event.format_time
      @event.merge_meetup_rsvps
      handle_response
    rescue Exception => e
      @msg = "Could not pull rsvps '#{@event.name}':" + '\n' + e.to_s
      render 'errors', format: :js
    end
  end

  def run_rsvp_update(event)
    Thread.new do
      event.merge_meetup_rsvps
    end
  end

  def new
    @event = Event.new
    @event.status = "approved"
    handle_response
  end
  
  def suggest
    @event = Event.new
    @event.status = "pending"
    handle_response
  end

  # handles panel add new event
  def create
    @is_approved = event_params[:status] == "approved"
    begin
      @event = Event.new(event_params)
      if @is_approved then
        @remote_event = Meetup.new.push_event(@event)
        @event.update_meetup_fields(@remote_event)
        @event.status = "approved"
        @msg = "Successfully added '#{@event.name}'!"
      else
        @msg = "Thank you for suggesting '#{@event.name}'!"
      end
      @event.save!
      success = true
    rescue Exception => e
      @msg = "Could not create '#{event_params[:name]}':" + '\n' + e.to_s
    end
    success ? handle_response : (render 'errors', format: :js)
  end

  def edit
    @event = Event.find params[:id]
    if @event.is_past?
      @msg = "Sorry, past events cannot be edited. You may only delete them."
      return render 'errors', format: :js
    end
    begin
      @new_status = params[:commit]
      if @new_status
        @statuses = {'accept' => 'approved', 'reject' => 'rejected'}
        @statuses.default = 'pending'
        @event.update(:status => @statuses[@new_status]) 
        @event.save
      end
      @event.save!
      
      handle_response
    rescue Exception => e
      @msg = "Undable to update '#{@event.name}'s status:" + '\n' + e.to_s
      return render 'errors', format: :js
    end
  end

  # does panel update event
  def update
    @event = Event.find params[:id]
    @is_approved = event_params[:status] == "approved"
    perform_update_transaction({ approved: @is_approved })
    @success ? handle_response : (render 'errors', format: :js)
  end

  def perform_update_transaction(options={})
    @event = Event.new(event_params)
    if options[:approved]
      begin
        if @event.meetup_id
          @remote_event = Meetup.new.edit_event({ event: event, id: @event.meetup_id })
        else
          @remote_event = Meetup.new.push_event(@event)
        end
        @event.update_attributes(event_params)
        @event.update_attributes(venue_name: remote_event[:venue_name])  # Necessary if meetup refused to create the venue
        @success = true
        @msg = "#{@event.name} successfully updated!"
      rescue Exception => e
        @msg = "Could not update '#{@event.name}':" + '\n' + e.to_s
      end
    else
      puts params
      original_event = Event.find(params[:id])
      puts original_event
      original_event.update_attributes(event_params)
      @success = true
      @msg = "#{@event.name} successfully updated!"
    end
  end

  # handles panel event delete
  def destroy
    @event = Event.find params[:id]
    @id = @event.id
    perform_destroy_transaction
    @success ? handle_response : (render 'errors', format: :js)
  end

  def perform_destroy_transaction
    begin
    if (@event.is_approved? && Meetup.new.delete_event(@event.meetup_id))
      @event.destroy
      @success = true
      @msg = "#{@event.name} event successfully deleted!"
    end
    rescue Exception => e
      @msg = "Failed to delete event '#{@event.name}':" + '\n' + e.to_s
    end
  end

  def handle_response
    respond_to do |format|
      format.html { redirect_to calendar_path }
      format.json { render nothing: true }
      format.js
    end
  end
  
  def edit_event_form
    @event = Event.find(params[:event_id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def search_events
    @events = Event.where("name LIKE ?", "#{params[:search]}%")
    respond_to do |format|
      format.js
    end
  end
    

  private

  def event_params
    params.require(:event).permit(:name, :status, :organization, :venue_name, :st_number, :st_name, :city,
                                  :state, :country, :start, :end, :description, :how_to_find_us, :image,
                                  :street_number,  :cost, :route, :locality, :family_friendly, :free,
                                  :contact_email, :contact_first, :contact_last, :contact_phone, :zip, :url,
                                  :category)
  end
end
