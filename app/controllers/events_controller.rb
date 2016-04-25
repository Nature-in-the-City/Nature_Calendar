class EventsController < ApplicationController
  #before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :third_party]

  before_filter :check_for_cancel, only: [:create, :update, :third_party, :pull_third_party]
  
  def check_for_cancel
    render 'default', format: :js  if params[:cancel]
    render 'pull_third_party', format: :js  if params[:cancel_third_party]
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
      @non_anon_guests_by_first_name = @event.guests.order(:first_name).where(is_anon: false)
      @event.merge_meetup_rsvps
      handle_response
    rescue Exception => e
      @msg = "Could not pull rsvps '#{@event.name}':" + '\n' + e.to_s
      render 'errors', format: :js
    end
  end

  def third_party
    begin
      @url = params[:url]
      if @url.present?
        @event = Event.get_remote_events({url: @url})
      end
      handle_response
    rescue Exception => e
      @msg = 'Could not perform the requested operation:' + '\n' + e.to_s
      render 'errors', format: :js
    end
  end

  def pull_third_party
    begin
      @ids = Event.get_event_ids(params)
      raise 'You must select at least one event. \nPlease retry.' if @ids.blank?
      @events = Event.store_third_party_events(@ids)
      @msg = 'Successfully added:' + '<br/>' + @events.map { |event| event.name }.join('<br/>')
      handle_response
    rescue Exception => e
      @msg = 'Could not pull events:' + '\n' + e.to_s
      render 'errors', format: :js
    end
  end

  def run_rsvp_update(event)
    event.merge_meetup_rsvps
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

  def assign_organization
    begin
      @org = params[:event_type_check] == 'third_party' ? Event.internal_third_party_group_name : Event.get_default_group_name
    rescue Exception
      @org = 'Unassigned'
    end
    @event.update_attributes(organization: @org)
  end

  # handles panel add new event
  def create
    #byebug
    @is_approved = event_params[:status] == "approved"
    begin
      @event = Event.new(event_params)
      if @is_approved then
        assign_organization
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
    puts 'inside EventsController#edit'
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
    puts 'inside EventsController#update'
    #byebug
    @event = Event.find params[:id]
    perform_update_transaction
    @success ? handle_response : (render 'errors', format: :js)
  end

  def perform_update_transaction
    #puts 'inside EventsController#perform_update_transaction'
    #byebug
    @event = Event.new(event_params)
    assign_organization
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
    if @event.is_third_party? || Meetup.new.delete_event(@event.meetup_id)
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


  private

  def event_params
    params.require(:event).permit(:name, :status, :organization, :venue_name, :st_number, :st_name, :city,
                                  :state, :country, :start, :end, :description, :how_to_find_us, :image,
                                  :street_number,  :cost, :route, :locality, :family_friendly, :free,
                                  :contact_email, :contact_first, :contact_last, :contact_phone, :zip, :url)
  end
end
