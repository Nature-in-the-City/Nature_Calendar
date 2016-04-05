class GuestsController < ActionController::Base
  helper_method :respond_js, :handle_guest_registration
  
  def new
    #puts params
    @event = Event.find(params[:event_id])
    respond_js
  end

  def create
    @event = Event.find(params[:event_id])
    if !Guest.fields_valid?(guest_params)
      @msg = "Failed to RSVP. Please fill out the First Name, Last Name, and Email fields, and mark whether you want to be anonymous to other guests."
      respond_js
      return
    end
    handle_guest_registration
    @msg = "Thank you for RSVPing for #{@event.name}! You will receive an email confirming your registration shortly."
    GuestMailer.rsvp_email(@guest, @event).deliver
    AdminMailer.admin_email(@guest, @event).deliver
    respond_js
  end

  def handle_guest_registration
    @guest = Guest.create!(guest_params)
    @guest.registrations.build({event_id: params[:event_id], guest_id: @guest.id})
    @guest.save
  end

  def respond_js
    respond_to do |format|
      format.js
    end
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :phone, :email, :address, :city, :state, :zip, :is_anon)
  end
end
