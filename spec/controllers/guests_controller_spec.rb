require 'rails_helper'

describe GuestsController do
    let(:test_event) { Event.create!( name: "hike", start: "Aug 25, 2016 2:00 PM",
                    end: "Aug 25, 2016 8:00 PM", description: "a hike",
                    contact_email: "abc@123.com" ) }
    before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:render)
        allow_any_instance_of(GuestsController).to receive(:respond_js).and_return(redirect_to calendar_path)
        allow(Event).to receive(:find).and_return(Event.where(contact_email: "abc@123.com"))
        allow(GuestMailer).to receive_message_chain(:rsvp_email, :deliver)
        allow(AdminMailer).to receive_message_chain(:admin_email, :deliver)
    end
                    
    describe "GET #new" do
        let(:call_new) { get :new, guest: { event_id: test_event.id } }
        it { expect{ call_new }.not_to raise_error }
    end
    
    describe "POST #create" do
        let(:test_guest) { post :create, guest: { event_id: 1, first_name: "Fred", last_name: "Poodle", is_anon: false } }
        context "valid guest params" do
            it { expect{ test_guest }.not_to raise_error }
        end
        context "when errors" do
            before(:each) do
                allow(Guest).to receive(:fields_valid?).and_return(false)
            end
            it { expect{ test_guest }.not_to raise_error }
        end
    end
    
    describe "#handle_guest_registration" do
        before(:each) do
            @valid_params = { event_id: 5, first_name: "John", last_name: "Doe",
                              email: "john@doe.com", phone: "555-555-5555",
                              address: "1234 street road", is_anon: false }
        end
        
        it "creates a new Guest" do
            expect{ post :create, :guest => @valid_params }.not_to raise_error
        end
    end

end