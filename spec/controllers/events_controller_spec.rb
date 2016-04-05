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
      allow_any_instance_of(ApplicationController).to receive(:render)
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
      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:render)
      end
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
        allow_any_instance_of(ApplicationController).to receive(:render)
        allow(Event).to receive(:get_remote_events).and_raise(StandardError)
      end
      it { expect{ get :third_party, id: "123" }.not_to raise_error }
      it { expect{ post :third_party, id: "123" }.not_to raise_error }
    end
  end
  
  describe "GET #index" do
    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:render)
    end
    context 'when there is a family-friendly filter' do
      let(:get_index_filter_family_friendly) { get :index, start: DateTime.now, filter: 'family_friendly' }
      it { expect{ get_index_filter_family_friendly }.not_to raise_error }
    end
    context 'when there is a free filter' do
      let(:get_index_filter_free) { get :index, start: DateTime.now, filter: 'free' }
      
      it { expect{ get_index_filter_free }.not_to raise_error }
    end
    context 'when there is not a filter' do
      let(:get_index_no_filter) { get :index, start: DateTime.now, filter: 'family_friendly' }
      it { expect{ get_index_no_filter }.not_to raise_error }
    end
  end
  
  describe "GET #show" do
    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:render)
    end
    context 'when event with provided id exists' do
      before(:each) do
        @valid_event = Event.create!(name: "a sample event", start: DateTime.now)
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
    let(:create_new_event) { post :create, event: {name: "Voldemort", start: 10.days.from_now} }
    it { expect{ create_new_event }.not_to raise_error }
  end

end
