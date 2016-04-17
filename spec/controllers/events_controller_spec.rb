require 'rails_helper'
require 'spec_helper'

describe EventsController do
  let(:get_third_party) { get :third_party }
  let(:post_third_party) { post :third_party }
  let(:get_pull_third_party) { get :pull_third_party }
  
  before :each do
    @user = User.create(email: "example@example.com",
                        password: "changeme")
    sign_in @user
    allow(Meetup).to receive_message_chain(:new, :push_event).
                  and_return(create(:event))
    allow_any_instance_of(ApplicationController).to receive(:render).and_return(200)
  end

  let(:event) {Event.create(name: 'coyote appreciation',
                                    organization: 'nature loving',
                                    start: '8-mar-2016',
                                    description: 'watch coyotes',
                                    contact_email: 'cayotyluvr123@gmail.com')}

  describe "#pull_third_party" do
    let(:ids) {['event123', 'event1456', 'eventABC']}
    let(:events) {[Event.new(name: 'nature', contact_email: '123@abc.com', start: DateTime.now),
                  Event.new(name: 'gardening', contact_email: '123@abc.com', start: DateTime.now),
                  Event.new(name: 'butterflies', contact_email: '123@abc.com', start: DateTime.now)]}

    before(:each) do
      allow(Event).to receive(:get_remote_events).and_return(nil)
      allow(Event).to receive(:process_remote_events).and_return(events)
    end

    context 'for some requested ids' do
      before(:each) do
        allow(Event).to receive(:get_requested_ids).and_return(ids)
      end
      it "should redirect to the calendar" do
        expect(get_pull_third_party).to redirect_to(calendar_path)
      end
    end

    context 'no requested ids' do
      before(:each) do
        allow(Event).to receive(:get_requested_ids).and_return([])
      end
      it "should redirect back to third party" do
        expect(get_pull_third_party).to redirect_to(third_party_events_path)
      end
      it "should return no pulled event names" do
        expect{ get_pull_third_party }.to change{ flash[:notice] }.to('You must select at least one event. Please retry.')
      end
    end
  end

  describe "#third_party" do
    context "GET #third_party" do
      it "redirects to calendar page" do
        expect(get_third_party).to redirect_to(calendar_path)
      end
      it "assigns empty events" do
        expect{ get_third_party }.not_to raise_error
        expect(assigns(:events)).to be_nil
      end
      it "handles exeception gracefully" do
        expect{ get :third_party, { id: 100000 } }.not_to raise_error
      end
    end
    context "POST #third_party" do
      let(:event) {[Event.new]}

      before(:each) do
        allow(Event).to receive(:get_remote_events).and_return(event)
      end
      it "redirects to calendar page" do
        expect(post_third_party).to redirect_to(calendar_path)
      end
      it "assigns events for posted id" do
        get :third_party, id: "123"
        expect(assigns(:events)).to eq(event)
      end
      it "assigns events for posted group_urlname" do
        get :third_party, group_urlname: "gruppetto"
        expect(assigns(:events)).to eq(event)
      end
    end
    context "when there are errors" do
      before(:each) do
        allow(Event).to receive(:get_remote_events).and_raise(StandardError)
      end
      it { expect{ get :third_party, id: "123" }.not_to raise_error }
      it { expect{ post :third_party, id: "123" }.not_to raise_error }
    end
  end
  
  describe "GET #index" do
    before(:each) do
      @family_friendly = create(:event, family_friendly: true, contact_email: "abc@123.com")
      @free = create(:event, free: true, contact_email: "a1b2c3@123.com")
      @both = create(:event, family_friendly: true, free: true, contact_email: "abc@123.com")
    end
    it 'should work' do
      expect{ get :index }.not_to raise_error
    end
    context 'when there is a family-friendly filter' do
      let(:get_index_filter_family_friendly) { get :index, filter: 'family_friendly' }
      let!(:family_friendly_relation) { Array.new([@family_friendly, @both]) }
      it 'should not raise an error when filtering by family-friendly' do
        expect{ get_index_filter_family_friendly }.not_to raise_error
      end
      it 'should not return non-family friendly events' do
        expect{ get_index_filter_family_friendly }.to change{ assigns(:events) }
      end
    end
    context 'when there is a free filter' do
      let(:get_index_filter_free) { get :index, filter: 'free' }
      
      it { expect{ get_index_filter_free }.not_to raise_error }
    end
    context 'when there is not a filter' do
      let(:get_index_no_filter) { get :index, start: DateTime.now, filter: 'family_friendly' }
      it { expect{ get_index_no_filter }.not_to raise_error }
    end
  end
  
  describe "GET #show" do
    context 'when event with provided id exists' do
      before(:each) do
        @valid_event = create(:event, name: "a sample event")
        @event_id = @valid_event.id
        get :show, { id: @event_id }
      end
      it 'should find the correct event' do
        expect(assigns(:event)).to eql(@valid_event) 
      end
    end
  end
  
  describe "GET #new" do
    let(:new_event) { get :new, { name: "Rspec test time", start: 10.days.from_now } }
    it { expect{ new_event }.not_to raise_error }
  end
  
  describe "POST #create" do
    let(:create_new_event) { post :create, event: {name: "Voldemort", start: 10.days.from_now, status: 'approved'} }
    it { expect{ create_new_event }.not_to raise_error }
    context 'when error occurs' do
      before(:each) do
        allow(Meetup).to receive_message_chain(:new, :push_event).and_raise(StandardError)
      end
      it 'should catch the error' do
        expect{ create_new_event }.not_to raise_error
        expect(assigns(:success)).to be_nil
      end
    end
  end
  
  describe "PATCH #update" do
    let(:event_patch) { create(:event, name: 'patch') }
    before(:each) do
      allow(Event).to receive(:find).and_return(event_patch)
      allow(Meetup).to receive_message_chain(:new, :edit_event).and_return(event_patch)
    end
    let(:update_event) { patch :update, id: 1, 
                        event: { name: 'patchy', start: 1.day.from_now } }
    it 'should not throw an error' do
      expect{ update_event }.not_to raise_error
    end
    context "when #update_attributes throws an error" do
      before(:each) do
        allow_any_instance_of(Event).to receive(:update_attributes).and_raise(StandardError)
      end
      it "should not throw an error" do
        expect{ update_event }.not_to raise_error
      end
    end
  end
  
  describe "DELETE #destroy" do
    let(:destroy_event) { delete :destroy, id: 1, event: {} }
    before(:each) do
      @event_destroy = Event.create!(name: 'destroy', contact_email: 'foxa2v3@abc.com', start: DateTime.now)
      allow(Event).to receive(:find).and_return(Event.find(@event_destroy.id))
    end
    context 'without errors' do
      it 'should not raise errors' do
        expect{ destroy_event }.not_to raise_error
      end
      
    end
    context 'when error' do
      let(:destroy_second_event) { delete :destroy, id: 2, event: {} }
      before(:each) do
        allow_any_instance_of(Event).to receive(:destroy).and_raise(StandardError)
      end
      it { expect{ destroy_second_event }.not_to raise_error }
    end
  end
  
  describe "GET #edit" do
    before(:all) do
      @edit_item = create(:event, name: "edit event", status: 'pending', start: 2.days.from_now, end: 2.days.from_now)
      @past_item = create(:event, name: "past event", status: 'pending', start: DateTime.now - 1, end: DateTime.now - 1)
    end
    let(:edit_item_id) { @edit_item.id }
    let(:past_item_id) { @past_item.id }
    let(:blank_edit_future) { get :edit, { id: edit_item_id, commit: "" } }
    let(:blank_edit_past) { get :edit, { id: past_item_id, commit: "" } }
    let(:accept_edit_future) { get :edit, { id: edit_item_id, commit: 'accept' } }
    let(:reject_edit_future) { get :edit, { id: edit_item_id, commit: 'reject' } }
    let(:accept_edit_past) { get :edit, { id: past_item_id, commit: 'accept' } }
    let(:item_to_edit) { Event.find(edit_item_id) }
    
    it 'should not throw an error when no change is specified' do
      expect{ blank_edit_future }.not_to raise_error
      expect{ blank_edit_past }.not_to raise_error
    end
    it 'should update the status of future events' do
      expect(item_to_edit.status).to eq('pending')
      
      expect{ reject_edit_future }.not_to raise_error
      expect(item_to_edit.status).to eq('rejected')
      
      expect{ accept_edit_future }.not_to raise_error
      expect(item_to_edit.status).to eq('approved')
    end
    it 'should should not update status of past events' do
      expect{ accept_edit_past }.not_to change{ Event.where(status: 'accepted').count }
    end
    context 'when save! errors' do
      before(:each) { allow_any_instance_of(Event).to receive(:save).and_raise(StandardError) }
      it 'should catch error and exit gracefully' do
        expect{ accept_edit_future }.not_to raise_error
      end
    end
  end
  
  describe "#assign_organization" do
    let(:event_to_assign) { post :create, event: {name: "Assignment Event", start: 10.days.from_now, status: 'approved'} }
    let(:pending_assign) { post :create, event: {name: "Assignment Event", start: 10.days.from_now, status: 'pending'} }
    before(:each) do
      allow(Event).to receive(:internal_third_party_group_name).and_return(nil)
    end
    it 'should assign the default organization name' do
      expect{ event_to_assign }.not_to raise_error
    end
    it 'should not throw an error' do
      expect{ pending_assign }.not_to raise_error
    end
  end
  
end
