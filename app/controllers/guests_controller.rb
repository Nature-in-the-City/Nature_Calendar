class GuestsController < ActionController::Base
  def create
    @event = Event.find(params[:event_id])
    if !Guest.fields_valid?(guest_params)
      @msg = "Please fill out all fields to RSVP."
      respond_js
      return
    end
    handle_guest_registration
    @msg = "Thank you for RSVPing for #{@event.name}! You will receive an email confirming your registration shortly."
    GuestMailer.rsvp_email(@guest, @event).deliver
    respond_js
  end

  def handle_guest_registration
    @guest = Guest.find_by_email(guest_params[:email]) || Guest.create!(guest_params)
    @guest.registrations.build({:event_id => params[:event_id], :guest_id => @guest.id})
    @guest.save
  end

  def respond_js
    respond_to do |format|
      format.js
    end
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :phone, :email, :address, :is_anon)
  end
end
