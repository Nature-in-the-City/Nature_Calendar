require 'rails_helper'
require 'spec_helper'

describe EventsController do
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

  describe "pulls 3rd party events" do
    let(:ids) {['event123', 'event1456', 'eventABC']}
    let(:events) {[Event.new(name: 'nature', email: '123@abc.com'),
                  Event.new(name: 'gardening', email: '123@abc.com'),
                  Event.new(name: 'butterflies', email: '123@abc.com')]}

    before(:each) do
      allow(Event).to receive(:get_remote_events).and_return(nil)
      allow(Event).to receive(:process_remote_events).and_return(events)
    end

    context 'for some requested ids' do
      before(:each) do
        allow(Event).to receive(:get_requested_ids).and_return(ids)
      end

      it "should redirect to the calendar" do
        get :pull_third_party
        expect(response).to redirect_to(calendar_path)
      end
    end

    context 'no requested ids' do
      before(:each) do
        allow(Event).to receive(:get_requested_ids).and_return([])
      end

      it "should redirect back to third party" do
        get :pull_third_party
        expect(response).to redirect_to(third_party_events_path)
      end

      it "should return no pulled event names" do
        get :pull_third_party
        expect(flash[:notice]).to eq('You must select at least one event. Please retry.')
      end
    end
  end

  describe "#third_party" do
    context "get" do
      it "renders the third_party template" do
        get :third_party
        expect(response).to render_template('third_party')
      end

      it "assigns empty events" do
        get :third_party
        expect(assigns(:events)).to eq([])
      end
    end

    context "post" do
      let(:event) {[Event.new]}

      before(:each) do
        allow(Event).to receive(:get_remote_events).and_return(event)
      end

      it "renders the third_party template" do
        post :third_party
        expect(response).to render_template('third_party')
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
  end

end
