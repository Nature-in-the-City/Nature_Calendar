require 'rails_helper'
require 'spec_helper'

describe CalendarsController do
  before(:each) do
    allow_any_instance_of(Meetup).to receive(:pull_events).and_return(nil)
  end


  describe 'gets the calendar' do
    it 'renders the calendar' do
      allow(Event).to receive(:get_remote_events).and_return([])
      get :show
      expect(response).to render_template(:show)
    end
  end
  
  describe 'in production mode' do
    subject { get :show }
    before(:each) do
      Rails.env.stub(production: true)
      request.stub(ssl: true)
    end
    it 'should redirect to http protocol' do
      expect(subject).not_to raise_error
      expect(response.redirect_url).to eql(request.url.gsub(/^http:/, 'https:'))
    end
  end
  
  describe 'show filter' do
    context 'when there is a filter' do
      let(:filter_by_free) { get :show, event: {filter: 'free'} }
      it 'should assign filter variable' do
        expect{ filter_by_free }.to change{ assigns(:filter) }.to('free')
      end
    end
  end

=begin
  describe 'synchronizing in #show' do
    context 'multiple events' do
      let(:events) {[Event.new, Event.new, Event.new]}

      it 'should call synchronize_events' do
        allow(Event).to receive(:synchronize_upcoming_events).and_return(events)
        expect(Event).to receive(:synchronize_upcoming_events)
        get :show
      end

    end


      it 'should indirectly get remote meetup events' do
        allow(Event).to receive(:get_remote_events).and_return(events)
        expect(Event).to receive(:get_remote_events)
        get :show
      end

      it 'should indirectly make remote meetup events local' do
        allow(Event).to receive(:get_remote_events).and_return(events)
        expect(Event).to receive(:process_remote_events).with(events)
        get :show
      end


    end

      it 'should display the newly added event names in a message' do
        events = [Event.new(name: 'chester'), Event.new(name: 'copperpot')]
        allow(Event).to receive(:process_remote_events).and_return(events)
        get :show
        expect(flash[:notice]).to eq("Successfully pulled events: #{events[0][:name]}, #{events[1][:name]} from Meetup")
      end

    end

    context "with failed result" do
      let(:event_names) {nil}

      it "should display a failure message" do
        allow(Event).to receive(:process_remote_events).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("Could not pull events from Meetup")
      end
    end

    context "with zero events returned (i.e. synch status)" do
      let(:event_names) {[]}

      it "should display a failure message" do
        allow(Event).to receive(:process_remote_events).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("The Calendar and Meetup are synched")
      end

    end


    context "with failed result" do
      let(:event_names) {nil}
      before(:each) do
        allow(Event).to receive(:get_remote_events).and_return([])
      end

      it "should display a failure message" do
        allow(Event).to receive(:process_remote_events).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("Could not pull events from Meetup")
      end
    end

    context "with zero events returned (i.e. synch status)" do
      let(:event_names) {[]}

      it "should display a failure message" do
        allow(Event).to receive(:process_remote_events).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("The Calendar and Meetup are synched")
      end
    end
  end
=end


end

