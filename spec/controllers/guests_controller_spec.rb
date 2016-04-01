require 'rails_helper'

describe GuestsController do
    before do
        @test_event = Event.create!( name: "hike", start: "Aug 25, 2016 2:00 PM", end: "Aug 25, 2016 8:00 PM", description: "a hike", contact_email: "abc@123.com" )
        @test_event_id = @test_event.id
    end
    describe "GET new" do
        it "calls #respond_js"
    end
    
    describe "POST create" do
        context "invalid guest params" do
            it "calls #respond_js"
            it "displays a message"
        end
        context "valid guest params" do
            it "calls #handle_guest_registration"
            it "delivers GuestMailer rsvp"
            it "delivers AdminMailer rsvp"
            it "calls #respond_js"
        end
    end
    
    describe "#handle_guest_registration" do
        before(:each) do
            @valid_params = { id: nil, event_id: @test_event_id, first_name: "John", last_name: "Doe",
                              email: "john@doe.com",phone: "555-555-5555", address: "1234 street road",
                              is_anon: false }
        end
        
        it "creates a new Guest" do
            Guest.should_receive(:new).with(@guest_params)
            post :create, :guest => @valid_params
        end
        
        it "creates a new Registation"
    end
    
    describe "#respond_js" do
    end
end