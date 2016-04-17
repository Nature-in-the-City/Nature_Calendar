require 'rails_helper'

describe Meetup do
  let(:meetup) {Meetup.new}

  describe '::build_date' do
    let(:date) {Time.utc(2015,4,11,0)}
    let(:date_in_millis) {date.to_i*1000}
    let(:utc_offset) {}

    it 'gets a time in milliseconds and returns a DateTime' do
      expect(Meetup.build_date(date_in_millis, utc_offset)).to eq(date)
    end
  end

  describe '::parse_event' do
    let(:time) {Time.now.to_i}
    let(:location) {double}
    let(:venue) {{id: '123'}}
    let(:data) {{'id' => '123',
                 'name' => 'paul',
                 'description' => 'what not',
                 'group' => {'name' => 'nature'},
                 'time' => time,
                 'duration' => time,
                 'utc_offset' => 1000,
                 'updated' => time,
                 'event_url' => 'url',
                 'how_to_find_us' => 'do not',
                 'status' => 'upcoming'}}
    let(:event) {{meetup_id: '123',
                  name: 'paul',
                  description: 'what not',
                  organization: 'nature',
                  start: time,
                  end: time,
                  updated: time,
                  url: 'url',
                  how_to_find_us: 'do not',
                  status: 'upcoming'}.merge!(venue)}

    before(:each) do
      allow(Meetup).to receive(:build_date).and_return(time)
      allow(Meetup).to receive(:parse_venue).and_return(venue)
    end

    it 'gets a hash with info and returns an event hash' do
      expect(Meetup.parse_event(data)).to eq(event)
    end
  end

  describe '::parse_rsvp' do
    let(:time) {double}
    let(:data) {{'event' => {'id' => '123'},
                 'member' => {'member_id' => '123', 'name' => 'pete'},
                 'guests' => '0',
                 'mtime' => time}}
    let(:rsvp) {{event_id: '123',
                 meetup_id: '123',
                 meetup_name: 'pete',
                 invited_guests: '0',
                 updated: time}}

    before(:each) do
      allow(Meetup).to receive(:build_date).and_return(time)
    end

    it 'gets a hash with info and returns an rsvp hash' do
      expect(Meetup.parse_rsvp(data)).to eq(rsvp)
    end
  end

  describe '#options_string' do
    let(:options)  {{id: '22', weight: '1000', sweet: 'true'}}
    let(:string) {'id=22&weight=1000&sweet=true'}

    it 'gets a hash of options and returns a string for urls' do
      expect(Meetup.options_string(options)).to eq(string)
    end
  end

=begin  REAL CALLS TO API
  describe '#pull_events' do
    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid group id (DEFAULT pull type)' do
        let(:data) {good_user.pull_events}

        it 'returns a possible collection of events' do
          expect(data.size).to be > 0
        end
      end

      context 'with valid event id' do


        it 'returns nil' do
          good_user.options.merge!({event_id: 'invalid_id'})
          data = good_user.pull_events
          expect(data).to be_nil
        end
      end

      context 'with valid group_urlname' do

        it 'returns nil' do
          good_user.options.merge!({event_id: 'invalid_name'})
          data = good_user.pull_events
          expect(data).to be_nil
        end
      end
    end
=end


  describe '#pull_events' do
    let(:data) {double}
    let(:results) {double}
    let(:event) {double}
    let(:events) {[event]}

    before(:each) do
      allow(data).to receive(:parsed_response).and_return(results)
      allow(results).to receive(:[]).with('results').and_return(events)
      allow(Meetup).to receive(:parse_event).with(any_args).and_return(event)
      allow(HTTParty).to receive(:get).with(any_args).and_return(data)
    end

    context 'with valid authorization key' do
      let(:valid_key) {'some key'}
      let(:good_user) {Meetup.new({key: valid_key})}

      context 'with valid group_urlname' do
        let(:valid_group_urlname) {'group'}

        before(:each) do
          allow(data).to receive(:code).and_return(200)
          allow(events[0]).to receive(:[]).with(:group_urlname).and_return(valid_group_urlname)
        end

        it 'returns the requested events' do
          data = good_user.pull_events(group_urlname: valid_group_urlname)
          expect(data[0][:group_urlname]).to eq(valid_group_urlname)
        end
      end

      context 'with invalid group_urlname' do
        let(:invalid_group_urlname) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
        end

        it 'returns nil' do
          data = good_user.pull_events(group_urlname: invalid_group_urlname)
          expect(data).to be_nil
        end
      end

      context 'with valid event id' do
        let(:valid_event_id) {"123"}

        before(:each) do
          allow(events[0]).to receive(:[]).with(:meetup_id).and_return(valid_event_id)
          allow(data).to receive(:code).and_return(200)
        end

        it 'returns the requested events' do
          data = good_user.pull_events(event_id: valid_event_id)
          expect(data[0][:meetup_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid event id' do
        let(:invalid_event_id) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
        end

        it 'returns nil' do
          data = good_user.pull_events(event_id: invalid_event_id)
          expect(data).to be_nil
        end
      end

      context 'with valid group id (DEFAULT pull type)' do
        let(:valid_group_id) {"123"}

        before(:each) do
          allow(events[0]).to receive(:[]).with(:group_id).and_return(valid_group_id)
          allow(data).to receive(:code).and_return(200)
        end

        it 'returns a possible collection of events' do
          data = good_user.pull_events(group_id: valid_group_id)
          expect(data[0][:group_id]).to eq(valid_group_id)
        end
      end

      context 'with invalid group id (DEFAULT pull type)' do
       # it can never be invalid
      end
    end


    context 'with invalid authorization' do
      let(:invalid_key) {'invalid'}
      let(:bad_user) {Meetup.new({key: invalid_key})}

      before(:each) do
        allow(data).to receive(:code).and_return(401)
      end

      it 'returns nil' do
        data = bad_user.pull_events
        expect(data).to be_nil
      end
    end
  end



=begin  REAL CALLS TO API
  describe '#pull_event' do
    let(:valid_event_id) {"219648262"}

    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid event id' do
        let(:data) {good_user.pull_event(valid_event_id)}

        it 'returns the requested event' do
          expect(data[:meetup_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid organization id' do
        let(:data) {good_user.pull_event('invalid_id')}

        it 'returns nil' do
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:bad_user) {Meetup.new({key: 'invalid_key'})}
      let(:data) {bad_user.pull_event(valid_event_id)}

      it 'returns nil' do
        expect(data).to be_nil
      end
    end
  end
=end


  describe '#pull_event' do
    let(:valid_event_id) {"123"}
    let(:data) {double}
    let(:results) {double}
    let(:event) {double}

    before(:each) do
      allow(data).to receive(:parsed_response).and_return(results)
      allow(results).to receive(:[]).with('results').and_return(nil)
      allow(Meetup).to receive(:parse_event).with(results).and_return(event)
      allow(event).to receive(:[]).with(:meetup_id).and_return(valid_event_id)
      allow(HTTParty).to receive(:get).with(any_args).and_return(data)
    end

    context 'with valid authorization key' do
      let(:valid_key) {'some_key'}
      let(:good_user) {Meetup.new({key: valid_key})}

      context 'with valid id' do
        before(:each) do
          allow(data).to receive(:code).and_return(200)
        end

        it 'returns the requested event' do
          data = good_user.pull_event(valid_event_id)
          expect(data[:meetup_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid id' do
        let(:invalid_event_id) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
        end

        it 'returns nil' do
          data = good_user.pull_event(invalid_event_id)
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:invalid_key) {'invalid'}
      let(:bad_user) {Meetup.new({key: invalid_key})}

      before(:each) do
        allow(data).to receive(:code).and_return(401)
      end

      it 'returns nil' do
        data = bad_user.pull_event(valid_event_id)
        expect(data).to be_nil
      end
    end
  end

=begin  REAL CALLS TO API
  describe '#pull_rsvps' do
    let(:valid_event_id) {'219648262'}

    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid event id' do
        let(:data) {good_user.pull_rsvps(valid_event_id)}

        it 'returns a possible collection of rsvps' do
         expect(data[0][:event_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid event id' do
        let(:data) {good_user.pull_rsvps('invalid_id')}

        it 'returns nil' do
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:bad_user) {Meetup.new({key: 'invalid_key'})}
      let(:data) {bad_user.pull_rsvps(valid_event_id)}

      it 'returns nil' do
        expect(data).to be_nil
      end
    end
  end
=end

  describe '#pull_rsvps' do
    let(:valid_event_id) {"123"}
    let(:data) {double}
    let(:results) {double}
    let(:rsvp) {double}
    let(:rsvps) {[rsvp]}

    before(:each) do
      allow(data).to receive(:parsed_response).and_return(results)
      allow(results).to receive(:[]).with('results').and_return(rsvps)
      allow(Meetup).to receive(:parse_rsvp).with(any_args).and_return(rsvp)
      allow(HTTParty).to receive(:get).with(any_args).and_return(data)
      allow(rsvp).to receive(:[]).with(:event_id).and_return(valid_event_id)
    end

    context 'with valid authorization key' do
      let(:valid_key) {'some key'}
      let(:good_user) {Meetup.new({key: valid_key})}

      context 'with valid event id' do
        before(:each) do
          allow(data).to receive(:code).and_return(200)
        end

        it 'returns a possible collection of rsvps' do
          data = good_user.pull_rsvps(event_id: valid_event_id)
          expect(data[0][:event_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid event id' do
        let(:invalid_event_id) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
        end

        it 'returns nil' do
          data = good_user.pull_rsvps(event_id: invalid_event_id)
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:invalid_key) {'invalid'}
      let(:bad_user) {Meetup.new({key: invalid_key})}

      before(:each) do
        allow(data).to receive(:code).and_return(401)
      end

      it 'returns nil' do
        data = bad_user.pull_rsvps(event_id: valid_event_id)
        expect(data).to be_nil
      end
    end
  end


  describe '#push_event' do
    let(:event) {Event.new(name: 'Testello', description: 'event o mine', venue_name: 'Moraga Steps', st_number: '', st_name: '16th Ave & Moraga St',
                           city: 'San Francisco', zip: '94111', state: 'ca', country: 'us',
                           start: DateTime.new(2015,5,10),  how_to_find_us: 'Follow the line')}
    let(:data) {double}

    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: 'valid_key', group_id:'1556336',
                                  group_urlname:'Meetup-API-Testing'})}

      context 'with existing local event' do
        it 'returns a hash with event data for a successful push' do
          allow(good_user).to receive(:get_event_data).and_return(name: 'Testello', description: 'event o mine',
                                                                  venue_id: 1515715,
                                                                  time: DateTime.new(2015,5,10).to_i*1000,
                                                                  how_to_find_us: 'Follow the line')
          allow(HTTParty).to receive(:post).and_return(data)
          allow(data).to receive(:code).and_return(201)
          allow(data).to receive(:parsed_response).and_return(data)
          allow(data).to receive(:[]).with('results').and_return(nil)
          allow(Meetup).to receive(:parse_event).with(data).and_return(Hash.new)
          result = good_user.push_event(event)
          expect(result).to be_instance_of(Hash)
        end
      end
    end

    context 'with invalid authorization' do
      let(:bad_user) {Meetup.new({key: 'invalid_id'})}

      it 'returns nil' do
        allow(bad_user).to receive(:get_event_data).and_return(name: 'Testello', description: 'event o mine',
                                                                venue_id: nil,
                                                                time: DateTime.new(2015,5,10).to_i*1000,
                                                                how_to_find_us: 'Follow the line')
        allow(HTTParty).to receive(:post).and_return(data)
        allow(data).to receive(:code).and_return(401)
        data = bad_user.push_event(event)
        expect(data).to be_nil
      end
    end
  end


  describe ".get_event_venue_data" do
    context "from a valid event" do
      let(:event) {Event.new(venue_name: 'Playa', st_number: '145', st_name: 'Peeep st.',
                                city: 'Gendale', zip: '6789',
                                state: 'CA', country: 'USA')}
      it "returns a hash of venue fields" do
        result = Meetup.get_event_venue_data(event)
        expect(result).to eq({name: 'Playa', address_1: '145 Peeep st.',
                              city: 'Gendale', zip: '6789',
                              state: 'CA', country: 'USA'})
      end
    end

    context "from an invalid event" do
      it "returns nothing" do
        result = Meetup.get_event_venue_data(nil)
        expect(result).to be_empty
      end
    end
  end

  describe "::parse_venue" do
    let(:meetup) {Meetup.new}

    context "from valid API-sent data" do
      let(:data) {{'venue'=> {'name' => 'Plaza', 'address_1'=> '145 Peeep st.',
                                 'city'=> 'Gendale', 'zip'=> '6789',
                                 'state'=> 'CA', 'country'=> 'USA'}}}

      it "returns a hash of venue fields" do
        result = Meetup.parse_venue(data)
        expect(result).to eq({venue_name: 'Plaza',  st_number: '145', st_name: 'Peeep st.',
                              city: 'Gendale', zip: '6789',
                              state: 'CA', country: 'USA'})
      end
    end

    context "from invalid data" do
      it "returns nothing" do
        result = Meetup.parse_venue(nil)
        expect(result).to be_empty
      end
    end
  end

  describe "#get_event_data" do
    let(:meetup) {Meetup.new}
    let(:id) {123}
    let(:event) {{'name' => 'Nature', 'description' => 'Nice one',
                  'start' => Time.now, 'duration' => '2', 'how_to_find_us' => 'do not',
                  'end' => Time.now + 1000000}}

    it "returns a hash of venue fields" do
      allow_any_instance_of(Meetup).to receive(:get_meetup_venue_id).and_return(id)
      result = meetup.get_event_data(event)
      expect(result).to eq({name: 'Nature', description: 'Nice one',
                               venue_id: id, time: Time.now.to_i*1000 + Meetup::UTC_OFFSET,
                               duration: 1000000000, how_to_find_us: 'do not'})
    end
  end

  describe "#create_venue" do
    let(:new_event) {Event.new(venue_name: 'Pepperpot', st_number: '145', st_name: 'Peeep st.',
                           city: 'Moon', zip: '94111',
                           state: 'CA', country: 'us')}
    let(:old_event) {Event.new(venue_name: 'Moraga Steps', st_number: '', st_name: '16th Ave & Moraga St',
                               city: 'San Francisco', zip: '94111',
                               state: 'CA', country: 'us')}
    let(:invalid_event) {Event.new(venue_name: 'Moraga Steps', st_number: '', st_name: '',
                               city: 'Sa', zip: '94111',
                               state: 'CA', country: 'us')}

    let(:data) {double}


    context "with valid key" do
      let(:good_user) {Meetup.new(group_urlname: 'Meetup-API-Testing')}
      before(:each) do
        allow(HTTParty).to receive(:post).and_return(data)
      end

      it "gets a response from meetup with new venue data" do
        allow(data).to receive(:code).and_return(201)
        response = good_user.create_venue(new_event)
        expect(response.code).to eq(201)
      end

      it "gets a response from meetup with old venue data" do
        allow(data).to receive(:code).and_return(409)
        response = good_user.create_venue(old_event)
        expect(response.code).to eq(409)
      end

      it "gets a response from meetup with failure" do
        allow(data).to receive(:code).and_return(400)
        response = good_user.create_venue(invalid_event)
        expect(response.code).to eq(400)
      end
    end

    context "with invalid key" do
      let(:bad_user) {Meetup.new(group_urlname: 'Meetup-API-Testing', key:'wrongkey')}
      before(:each) do
        allow(HTTParty).to receive(:post).and_return(data)
        allow(data).to receive(:code).and_return(401)
      end

      it "gets a not authorized error response from meetup" do
        response = bad_user.create_venue(new_event)
        expect(response.code).to eq(401)
      end

    end
  end

  describe "#get_meetup_venue_id" do
    let(:new_event) {Event.new(venue_name: 'Pepperpot', st_number: '145', st_name: 'Peeep st.',
                               city: 'Moon', zip: '94111',
                               state: 'CA', country: 'us')}
    let(:old_event) {Event.new(venue_name: 'Moraga Steps', st_number: '', st_name: '16th Ave & Moraga St',
                               city: 'San Francisco', zip: '94111',
                               state: 'CA', country: 'us')}
    let(:invalid_event) {Event.new(venue_name: 'Moraga Steps', st_number: '', st_name: '',
                                   city: 'Sa', zip: '94111',
                                   state: 'CA', country: 'us')}
    let(:id) {'1234'}
    let(:data) {double}
    let(:response) {double}


    context "with valid key" do
      let(:good_user) {Meetup.new(group_urlname: 'Meetup-API-Testing')}
      before(:each) do
        allow(good_user).to receive(:create_venue).and_return(data)
      end

      it "gets a response from meetup with new venue data" do
        allow(data).to receive(:code).and_return(201)
        allow(data).to receive(:parsed_response).and_return(response)
        allow(response).to receive(:[]).and_return(id)
        response = good_user.get_meetup_venue_id(new_event)
        expect(response).to eq(id)
      end

      it "gets a response from meetup with old venue data" do
        allow(data).to receive(:code).and_return(409)
        allow(Meetup).to receive(:get_matched_venue_id).with(data).and_return(id)
        response = good_user.get_meetup_venue_id(old_event)
        expect(response).to eq(id)
      end

      it "gets a response from meetup with failure" do
        allow(data).to receive(:code).and_return(400)
        response = good_user.get_meetup_venue_id(invalid_event)
        expect(response).to eq(nil)
      end
    end

    context "with invalid key" do
      let(:bad_user) {Meetup.new(group_urlname: 'Meetup-API-Testing', key:'wrongkey')}
      before(:each) do
        allow(bad_user).to receive(:create_venue).and_return(data)
        allow(data).to receive(:code).and_return(401)
      end

      it "gets a not authorized error response from meetup" do
        response = bad_user.get_meetup_venue_id(new_event)
        expect(response).to eq(nil)
      end
    end
  end

  describe ".get_matched_venue_id" do
    let(:id) {1234}
    let(:data) {double}

    it "returns the id from venue data received from meetup" do
      errors = double
      error =  double
      venue = double
      venues = double
      response = double
      allow(data).to receive(:parsed_response).and_return(response)
      allow(response).to receive(:[]).with('errors').and_return(errors)
      allow(errors).to receive(:[]).with(0).and_return(error)
      allow(error).to receive(:[]).with('potential_matches').and_return(venues)
      allow(venues).to receive(:[]).with(0).and_return(venue)
      allow(venue).to receive(:[]).with('id').and_return(id)
      result = Meetup.get_matched_venue_id(data)
      expect(result).to eq(id)
    end
  end

  describe '#delete' do
    let(:id) {'221807931'}
    let(:data) {double}
    before(:each) do
      allow(HTTParty).to receive(:delete).and_return(data)
    end

    context "with valid key" do
      let(:good_user) {Meetup.new}

      it "returns true for a successful deletion" do
        allow(data).to receive(:code).and_return(200)
        response = good_user.delete_event(id)
        expect(response).to be_truthy
      end

      it "returns false for a failed deletion" do
        allow(data).to receive(:code).and_return(404)
        response = good_user.delete_event(id)
        expect(response).to be_falsey
      end
    end

    context "with invalid key" do
      let(:bad_user) {Meetup.new(key:'wrongkey')}

      it "returns false" do
        allow(data).to receive(:code).and_return(401)
        response = bad_user.delete_event(id)
        expect(response).to be_falsey
      end
    end
  end

  describe '#edit_event' do
    let(:id) {221807724}
    let(:data) {double}

    context 'with valid authorization key' do
      let(:good_user) {Meetup.new}

      context 'with existing event' do
        it 'returns true for a successful edit' do
          allow(HTTParty).to receive(:post).and_return(data)
          allow(data).to receive(:code).and_return(200)
          data = good_user.edit_event({id: id, updated_fields: {}})
          expect(data).to be_truthy
        end
      end
    end

    context 'with invalid authorization' do
      let(:bad_user) {Meetup.new({key: 'invalid_id'})}

      it 'returns false' do
        allow(HTTParty).to receive(:post).and_return(data)
        allow(data).to receive(:code).and_return(401)
        data = bad_user.edit_event({id: id, updated_fields: {}})
        expect(data).to be_falsey
      end
    end
  end
  
  describe "#get_venues" do
    before(:each) do
      allow(HTTParty).to receive(:get)
      allow(Meetup).to receive(:process_result)
    end
    let(:obj) { Meetup.new }
    it { expect{ obj.get_venues }.not_to raise_error }
  end
  
  describe ".build_date" do
    it { expect(Meetup.build_date(nil)).to be_nil }
    it { expect(Meetup.build_date(Time.now)).not_to be_nil }
  end
  
  describe ".get_milliseconds" do
    it { expect(Meetup.get_milliseconds(nil)).to be_nil }
    it { expect(Meetup.get_milliseconds(Time.now)).not_to be_nil }
  end
  
end

