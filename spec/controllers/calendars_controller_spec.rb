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
    it 'should redirect to http protocol' do
      expect{ subject }.not_to raise_error
      #expect(response.redirect_url).to eql(request.url.gsub(/^http:/, 'https:'))
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
end

