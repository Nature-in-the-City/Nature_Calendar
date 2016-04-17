require 'spec_helper'
require 'rails_helper'

RSpec.describe Event, type: :model do
  
  describe "#is_new?" do
    context "with a new event" do
      it "returns positive" do
        event = Event.new(name: "new event", start: 1.day.from_now)
        result = event.is_new?
        expect(result).to be_truthy
      end
    end
    context "with an already pulled event" do
      it "returns negative" do
        id = '1000'
        event = Event.create!(name: "new event", start: 1.day.from_now, meetup_id: id)
        result = event.is_new?
        expect(result).to be_falsey
      end
    end
  end

  describe "#is_updated" do
    context "with updated event" do
      it "returns true" do
        event = Event.new(updated: Time.now)
        result = event.needs_updating?(Time.now + 3600)
        expect(result).to be_truthy
      end
    end
    context "with no event update" do
      it "returns false" do
        event = Event.new(updated: Time.now)
        result = event.needs_updating?(Time.now)
        expect(result).to be_truthy
      end
    end
  end

  describe "#format_start_date" do
    let(:date) {Time.utc(2002, 10, 31, 0, 2)}
    let(:formatted_date) {'Oct 30, 2002 at  4:02pm'}
    it "returns the date in a simpler form" do
      event = Event.new(start: date)
      result = event.format_start_date
      expect(result).to eq(formatted_date)
    end
  end

  describe "#format_end_date" do
    let(:date) {Time.utc(2002, 10, 31, 0, 2)}
    let(:formatted_date) {'Oct 30, 2002 at  4:02pm'}
    it "returns the date in a simpler form" do
      event = Event.new(end: date)
      result = event.format_end_date
      expect(result).to eq(formatted_date)
    end
  end
  
  describe ".process_remote_events" do
    let(:event) {[Event.new]}
    context "with new events" do
      it "saves the event in the db" do
        expect_any_instance_of(Event).to receive(:save)
        Event.process_remote_events(event)
      end
    end
    context "with an updated event" do
      it "updates an already stored event with the fields of the input event" do
        event[0][:meetup_id] = '123'
        event[0][:updated] = Time.now + 200000
        old_event = Event.new(updated: Time.now, meetup_id: '123')
        allow(Event).to receive(:find_by_meetup_id).with(123).and_return(old_event)
        expect(old_event).to receive(:apply_update)
        Event.process_remote_events(event)
      end
    end
    context "with an old event" do
      it "does nothing for an old unchanged event" do
        event[0][:meetup_id] = '123'
        event[0][:updated] = Time.now
        stored_event = Event.new(updated: Time.now, meetup_id: '123')
        allow(Event).to receive(:find_by_meetup_id).with(123).and_return(stored_event)
        expect(stored_event).not_to receive(:apply_update)
        Event.process_remote_events(event)
      end
    end
  end

  describe "#merge_meetup_rsvps" do
    let(:event) {Event.new(id: 1)}
    let(:rsvp) {[{event_id:"qdwhxgytgbxb", meetup_id:82190912,
                  meetup_name:"Amber Hasselbring", invited_guests:0,
                  updated: Time.now}]}
    let(:guest) {Guest.new(id: 1, first_name: 'chester', last_name: 'copperpot')}
    before(:each) do
        allow_any_instance_of(Event).to receive(:get_remote_rsvps).and_return(rsvp)
        allow(Guest).to receive(:find_by_meetup_rsvp).and_return(guest)
    end
    context "with new events" do
      it "saves the rsvp in the db" do
        allow(Registration).to receive(:find_by).and_return(nil)
        expect(Registration).to receive(:create!)
        event.merge_meetup_rsvps
      end
    end
    context "with an updated event" do
      it "updates an already stored event" do
        old_rsvp = Registration.new(updated: Time.now - 30000)
        allow(Registration).to receive(:find_by).and_return(old_rsvp)
        expect(old_rsvp).to receive(:update_attributes!)
        event.merge_meetup_rsvps
      end
    end
    context "with an old unchanged event" do
      it "does nothing for an old unchanged event" do
        stored_rsvp = Registration.new(updated: Time.now)
        allow(Registration).to receive(:find_by).and_return(stored_rsvp)
        expect(stored_rsvp).not_to receive(:update_attributes!)
        event.merge_meetup_rsvps
      end
    end
  end


  describe "#apply_update" do
    let(:event) {Event.new(name: 'walking')}
    context "with updated event" do
      let(:other_event) {Event.new(name: 'sitting')}
      it "computes the updated key value pairs and updates self" do
        expect(event).to receive(:update_attributes).with('name' => 'sitting')
        event.apply_update(other_event)
      end
    end
    context "with unchanged event" do
      let(:other_event) {Event.new(name: 'walking')}
      it "finds no updated key value pairs and it does not update self" do
        expect(event).to receive(:update_attributes).with({})
        event.apply_update(other_event)
      end
    end
  end
  
  describe '#street_address' do
    context 'when st_number' do
      let(:number_only) { Event.new(st_number: 1212) }
      it { expect{number_only.street_address}.not_to raise_error }
      it { expect(number_only.street_address).to be_nil }
    end
    context 'when st_address' do
      let(:street_only) { Event.new(st_name: "street") }
      it { expect{street_only.street_address}.not_to raise_error }
      it { expect(street_only.street_address).to be_nil }
    end
    context 'when st_number and st_address' do
      let(:number_street) { Event.new(st_number: 1212, st_name: "street  road  ") }
      it { expect{number_street.street_address}.not_to raise_error }
      it { expect(number_street.street_address).to eql("1212 Street Road") }
    end
  end
  
  describe '#city_state_zip' do
    context 'when none' do
      let(:no_fields) { Event.new }
      it { expect{no_fields.city_state_zip}.not_to raise_error }
      it { expect(no_fields.city_state_zip).to be_nil }
    end
    context 'when city' do
      let(:city_only) { Event.new(city: "san  diego") }
      it { expect{city_only.city_state_zip}.not_to raise_error }
      it { expect(city_only.city_state_zip).to eql("San Diego, CA") }
    end
    context 'when zip' do
      let(:zip_only) { Event.new(zip: 92101) }
      it { expect{zip_only.city_state_zip}.not_to raise_error }
      it { expect(zip_only.city_state_zip).to eql("92101") }
    end
    context 'when city, state, and zip' do
      let(:all_fields) { Event.new(city: "highland park", state: "TX", zip: 75205) }
      it { expect{all_fields.city_state_zip}.not_to raise_error }
      it { expect(all_fields.city_state_zip).to eql("Highland Park, TX 75205") }
    end
  end
  
  describe '#location' do
    context "when neither" do
      let(:neither) { Event.new }
      it { expect{neither.location}.not_to raise_error }
      it { expect(neither.location).to eql("Unavailable")}
    end
    context "when #street_address" do
      let(:st_only) { Event.new(st_number: 1212, st_name: "BerKelEy  road") }
      it { expect{st_only.location}.not_to raise_error }
      it { expect(st_only.location).to eql("Unavailable")}
    end
    context "when #city_state_zip" do
      let(:city_fields) { Event.new(city: "highland  park ", state: "TX", zip: 75205) }
      it { expect(city_fields.location).to eql("Highland Park, TX 75205, USA") }
    end
    context "when both" do
      let(:all_location_fields) { Event.new(st_number: 1212, st_name: "BerKelEy  road",
                                  city: "highland  park ", state: "TX", zip: 75205) }
      it { expect(all_location_fields.location).to eql("1212 Berkeley Road, Highland Park, TX 75205") }
    end
  end
  
  describe '.remove_remotely_deleted_events' do
    before(:each) do
      @event_1 = Event.create!(name: "event 1", meetup_id: '12345', start: DateTime.now)
      @event_2 = Event.create!(name: "event 2", meetup_id: '678910', start: DateTime.now)
      @local_events = [@event_1, @event_2]
    end
    context 'with no remote deletions' do
      let(:remote_events) { @local_events }
      it 'does nothing' do
        expect{ Event.remove_remotely_deleted_events(remote_events) }.not_to change{ Event.count }
      end
    end
    context 'with one remote deletion (@event_2)' do
      let(:remote_events) { [@event_2] }
      it 'deletes the local copy of @event_2' do
        Event.remove_remotely_deleted_events(remote_events)
        expect(Event.find_by_meetup_id('678910')).to be_nil
      end
    end
    context 'with one remote addition' do
      let(:new_event) {Event.create!(name: "new_event", start: DateTime.now, meetup_id: '55555555')}
      let(:remote_events) {[@event_1, new_event]}
      it 'does nothing' do
        Event.remove_remotely_deleted_events(remote_events)
        expect(Event.all.size).to eq(@local_events.size)
      end
    end
    context 'with one remote addition' do
      let(:new_event) {Event.create!(name: "new_event", start: DateTime.now, meetup_id: '55555555')}
      let(:remote_events) {[@event_1, new_event]}
      it 'does nothing' do
        Event.remove_remotely_deleted_events(remote_events)
        expect(Event.all.size).to eq(@local_events.size)
      end
    end
  end

  describe '.get_remotely_deleted_ids' do
    before(:each) do
      @event_1 = Event.create!(meetup_id: '12345', start: DateTime.now)
      @event_2 = Event.create!(meetup_id: '678910', start: DateTime.now)
      @local_events = [@event_1, @event_2]
    end
    context 'with no remote deletions' do
      let(:remote_events) {@local_events}
      it 'returns empty id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq([])
      end
    end
    context 'with one remote deletion (@event_2)' do
      let(:remote_events) {[@event_1]}
      it 'returns the id of @event_2' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq(['678910'])
      end
    end
    context 'with equal events but one remote addition' do
      let(:new_event) {Event.create!(meetup_id: '55555555')}
      let(:remote_events) {@local_events.concat [new_event]}
      it 'returns empty id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq([])
      end
    end
    context 'with all remote events deleted' do
      let(:remote_events) {[]}
      it 'returns full local id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq(["12345", "678910"])
      end
    end
    context 'with no local events' do
      let(:remote_events) {@local_events}
      before(:each) do
        @local_events.each {|event| event.destroy!}
      end
      it 'return empty id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq([])
      end
    end
  end

  describe ".get_requested_ids" do
    let(:data) {{event123: "1", e123vent: "2", evenABC: "3", event: "4", event12abc: "5"}}
    it "Selects only ids which match /^event.*/" do
      result = Event.get_requested_ids(data)
      expect(result).to eq([:event123, :event12abc])
    end
  end

  describe ".cleanup_ids" do
    let(:dirty_ids) {['event123', 'event1456', 'eventABC']}
    let(:clean_ids) {['123', '1456', 'ABC']}

    it 'should return only pure ids' do
      result = Event.cleanup_ids(dirty_ids)
      expect(result).to eq(clean_ids)
    end
  end
  
  describe ".get_upcoming_third_party_events" do
    context "when there are none" do
      it { expect(Event.get_upcoming_third_party_events).to eq([]) }
    end
    context "when there are some" do
      before(:each) do
        @return_ids = [656555556, 656555558]
        allow(Event).to receive(:get_stored_upcoming_third_party_ids).and_return(@return_ids)
      end
      it { expect(Event.get_upcoming_third_party_events).not_to be_nil }
    end
  end
  
  describe ".get_past_third_party_events" do
    context "when there are none" do
      before(:each) do
        allow(Event).to receive(:get_stored_past_third_party_ids).and_return([])
      end
      it { expect(Event.get_past_third_party_events).to eq([]) }
    end
    context "when there are some" do
      before(:each) do
        @return_ids = [656555556, 656555558]
        allow(Event).to receive(:get_stored_past_third_party_ids).and_return(@return_ids)
      end
      it { expect(Event.get_past_third_party_events).not_to be_nil }
    end
  end
  
  describe ".get_events_by_status" do
    let(:each_status) { %w(pending approved rejected) }
    let(:each_filter) { %w(approved family_friendly free hike play learn volunteer past upcoming) }
    it 'does not raise errors for any status' do
      each_status.each do |status|
        each_filter.each do |filter|
          expect { Event.get_events_by_status(status, filter) }.not_to raise_error
        end
        expect { Event.get_events_by_status(status, "") }.not_to raise_error
      end
    end
  end
   
  
  describe ".get_default_group_name" do
    it { expect{ Event.get_default_group_name }.not_to raise_error }
  end
  
  describe ".internal_third_party_group_name" do
    it { expect{ Event.internal_third_party_group_name }.not_to raise_error }
  end
  
  describe "#is_third_party?" do
    let(:is_third) { Event.new }
    it { expect(is_third.is_third_party?).to be_truthy }
  end
  
  describe ".synchronize_upcoming_events" do
    context "without group or third party events" do
      before(:each) do
        allow(Event).to receive(:get_upcoming_events).and_return([])
        allow(Event).to receive(:get_upcoming_third_party_events).and_return([])
        allow(Event).to receive(:remove_remotely_deleted_events)
        allow(Event).to receive(:process_remote_events)
      end
      it { expect{Event.synchronize_upcoming_events}.not_to raise_error }
    end
  end

  describe '.initialize_calendar_db' do
    let(:event1) {Event.new(meetup_id: '123565')}
    let(:event2) {Event.new(meetup_id: '653434')}
    let(:event3) {Event.new(meetup_id: '5654334')}
    let(:upcoming_events) {[event1]}
    let(:past_events) {[event2, event3]}

    context 'with both past and upcoming events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_upcoming_events).and_return(upcoming_events)
      end
      it 'returns sum of events' do
        result = Event.initialize_calendar_db
        expect(result).to eq(upcoming_events + past_events)
      end
    end
    context 'with only past events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_upcoming_events).and_return(nil)
      end
      it 'returns nothing' do
        result = Event.initialize_calendar_db
        expect(result).to be_nil
      end
    end
    context 'with only upcoming events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_upcoming_events).and_return(upcoming_events)
      end
      it 'returns sum of events' do
        result = Event.initialize_calendar_db
        expect(result).to be_nil
      end
    end
    context 'with no events at all' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_upcoming_events).and_return(nil)
      end
      it 'returns sum of events' do
        result = Event.initialize_calendar_db
        expect(result).to be_nil
      end
    end
  end
  
  describe '.get_upcoming_events' do
    before(:each) do
      allow(Event).to receive(:get_remote_events).and_return([])
    end
    it { expect(Event.get_upcoming_events).to eq([]) }
  end

  describe '.get_past_events' do
    let(:events) {[double, double]}
    before(:each) do
      allow(Event).to receive(:get_remote_events).and_return(events)
    end
    it 'calls get_remote_events with the right params' do
      expect(Event).to receive(:get_remote_events).with({status: 'past', time: '-1,'})
      Event.get_past_events(-1)
    end
  end

  describe '.synchronize_past_events' do
    let(:event1) {Event.new(name: 'sync_past test event', meetup_id: '123565', organization: 'Nature in the City')}
    let(:third1) {Event.new(name: 'synchronize test event', meetup_id: '653434', organization: 'Nature')}
    let(:third2) {Event.new(name: 'synchronize_past test event', meetup_id: '5654334', organization: 'Flower')}
    let(:past_events) {[event1]}
    let(:third_events) {[third1, third2]}
    
    context 'with both past and upcoming events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_past_third_party_events).and_return(third_events)
      end
      it 'returns sum of events' do
        result = Event.synchronize_past_events
        expect(result).to eq(past_events + third_events)
      end
    end
    context 'with only past events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_past_third_party_events).and_return(nil)
      end
      it 'returns nothing' do
        result = Event.synchronize_past_events
        expect(result).to be_nil
      end
    end

    context 'with only third party events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_past_third_party_events).and_return(third_events)
      end
      it 'returns nothing' do
        result = Event.synchronize_past_events
        expect(result).to be_nil
      end
    end
    context 'with no events at all' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_past_third_party_events).and_return(nil)
      end
      it 'returns sum of events' do
        result = Event.synchronize_past_events
        expect(result).to be_nil
      end
    end
  end
  
  describe ".update_statuses" do
    before(:all) do
      @past_event = Event.create!(name: "Past Event", start: "Sept 1, 2015 10:00 AM", end: "Sept 1, 2015 4:00 PM", status: "past")
      @pending_event = Event.create!(name: "Pending Event", start: DateTime.now + 1, end: DateTime.now + 1.5, status: "pending")
      @upcoming_event = Event.create!(name: "Upcoming Event", start: DateTime.now + 2, end: DateTime.now + 2.5, status: "approved")
    end
    after(:all) do
      to_destroy = [@past_event, @pending_event, @upcoming_event]
      to_destroy.each do |event|
        Event.where(:name => event.name).destroy_all
      end
    end
    context "when everything is up to date" do
      it "should not change any statuses" do
        expect{Event.update_statuses}.to_not change{@upcoming_event.reload.status}
        expect{Event.update_statuses}.to_not change{@past_event.reload.status}
        expect{Event.update_statuses}.to_not change{@pending_event.reload.status}
      end
    end
    context "when some statuses are incorrect" do
      it "should change incorrect statuses" do
        @upcoming_event.update(start: DateTime.now - 1)
        expect{Event.update_statuses}.to change{@upcoming_event.reload.status}.from("approved").to("past")
        @pending_event.update(start: DateTime.now - 1)
        expect{Event.update_statuses}.to change{@pending_event.reload.status}.from("pending").to("past")
      end
      it "should not change correct statuses" do
        expect(@past_event.reload.status).to eql("past")
        expect{Event.update_statuses}.to_not change{@past_event.reload.status}
      end
    end
  end
  
  describe "#tag_string" do
    before(:all) do
      @with_tags = Event.new(name: "Event with tags", family_friendly: true, free: true, category:"hike", start: DateTime.now + 1)
      @without_tags = Event.new(name: "Event without tags", start: DateTime.now + 1)
    end
    context "when an event has no tags" do
      it "should not error" do
        expect{@without_tags.tag_string}.not_to raise_error
      end
      it "should return 'Uncategorized'" do
        value = @without_tags.tag_string
        expect(value).to eql("Uncategorized")
      end
    end
    context "when an event does have tags" do
      it "should not raise an error" do
        expect{@with_tags.tag_string}.not_to raise_error
      end
      it "should return the names of true tag values" do
        value = @with_tags.tag_string
        expect(value).to eql("Family-Friendly, Free, Hike")
      end
    end
  end
  
  describe ".format_tag" do
    it "should correct capitalization" do
      capitalization = Event.format_tag "BaNaNAs"
      expect(capitalization).to eql("Bananas")
    end
    context "when there is a hyphen" do
      it "should not error" do
        expect{Event.format_tag "hello_there"}.not_to raise_error
      end
      it "should replace hyphen with dash" do
        replace_hyphen = Event.format_tag "hElLo_there_weirdo"
        expect(replace_hyphen).to eql("Hello-There-Weirdo")
      end
      it "should not add dashes to the front or end" do
        two_words = Event.format_tag "_HeLlO_WiScOnSiN__"
        one_word = Event.format_tag "_HeLlO_"
        expect(two_words).to eql("Hello-Wisconsin")
        expect(one_word).to eql("Hello")
      end
    end
    context "when there is not a hyphen" do
      it "should not add a hyphen" do
        no_hyphen = Event.format_tag "Hello there friend"
        expect(no_hyphen).to eql("Hello there friend")
      end
    end
  end
  
  describe "#at_least_1_day_long?" do
    before(:all) do
      @is_one_day = Event.new(name: "day-long event", start: DateTime.now, end: DateTime.now + 1)
      @less_than_one_day = Event.new(name: "half-day event", start: DateTime.now, end: DateTime.now + 0.5)
      @greater_than_one_day = Event.new(name: "two-day event", start: DateTime.now, end: DateTime.now + 2)
    end
    puts "in 1_day"
    context "when event is less than a day long" do
      it "should return false" do
        expect(@less_than_one_day.at_least_1_day_long?).to be_falsey
      end
    end
    context "when an event is at least a day long" do
      it "should return true" do
        expect(@greater_than_one_day.at_least_1_day_long?).to be_truthy
        expect(@is_one_day.at_least_1_day_long?).to be_truthy
      end
    end
  end
  
  describe "#format_time" do
    before(:all) do
      eql = DateTime.now
      @start_eqls_end = Event.new(name: "start = end", start: eql, end: eql)
      @start_and_end_unique = Event.new(name: "start != end", start: DateTime.now, end: DateTime.now + 1)
      @just_start = Event.new(name: "!end", start: DateTime.now)
    end
    context "when formatted correctly" do
      it "should not error" do
        expect{@start_and_end_unique.format_time}.not_to raise_error
      end
      it "should return the correct time" do
        expect(@start_and_end_unique.format_time).to eql("#{@start_and_end_unique.format_start_date} to #{@start_and_end_unique.pick_end_time_type}")
      end
    end
    context "when incorrectly formatted" do
      it "should not error" do
        expect{@start_eqls_end.format_time}.not_to raise_error
        expect{@just_start.format_time}.not_to raise_error
      end
      it "should return the start time" do
        expect(@start_eqls_end.format_time).to eql("#{@start_eqls_end.format_start_date}")
        expect(@just_start.format_time).to eql("#{@just_start.format_start_date}")
      end
    end
  end
  
  describe "#is_past?" do
    context "when event is past" do
      it "should return true" do
        past_event = Event.new(name: "Past Event", start: 1.day.ago, end: 1.day.ago + 0.5)
        expect(past_event.is_past?).to be_truthy
      end
    end
    context "when event is in the future" do
      it "should return false" do
        future_event = Event.new(name: "Future Event", start: 2.days.from_now, end: 2.days.from_now + 0.5)
        expect(future_event.is_past?).to be_falsey
      end
    end
  end
  
  describe ".get_event_ids" do
    before(:each) do
      allow(Event).to receive(:cleanup_ids)
      allow(Event).to receive(:get_requested_ids)
    end
    it 'should not error with nil params' do
      expect{ Event.get_event_ids(nil) }.not_to raise_error
    end
    it 'should not error with non-nil params' do
      expect{ Event.get_event_ids(10) }.not_to raise_error
    end
  end
  
  describe "#update_meetup_fields" do
    let(:event_to_update) { Event.create!(name: "original event", start: 1.day.from_now) }
    let(:updated_event) { Event.new(meetup_id: 11111, status: 'approved', url: 'google.com/some_page') }
    let(:action) { event_to_update.update_meetup_fields(updated_event) }
    it { expect{ action }.to change{ event_to_update.meetup_id }.from(nil).to(updated_event.meetup_id) }
    it { expect{ action }.to change{ event_to_update.status }.from('pending').to(updated_event.status) }
    it { expect{ action }.to change{ event_to_update.url }.from(nil).to(updated_event.url) }
    it { expect{ action }.not_to change{ event_to_update.updated } }
  end
  
  describe ".get_remote_meetup/google_events" do
    before(:each) do
        @event1 = build(:event, name: "event1", start: DateTime.now + 2)
        @event2 = build(:event, name: "event2", start: DateTime.new + 3)
        allow(Meetup).to receive_message_chain(:new, :pull_events).and_return([@event1, @event2])
        
        @google_event1 = build(:event, name: "Simple google event", start: DateTime.now + 2)
        @google_event2 = build(:event, name: "Another google event", start: DateTime.new + 3)
        allow(Google).to receive_message_chain(:new, :pull_events).and_return([@google_event1, @google_event2])
    end
    let(:pull_google) { Event.get_remote_google_events({ url: "www.google.com/natureinthecity", group_urlname: '12abc' }) }
    let(:pull_meetup) { Event.get_remote_meetup_events({ url: "www.meetup.com/natureinthecity", group_urlname: 'abc123' }) }
    it { expect{ pull_meetup }.not_to raise_error }
    it { expect{ pull_google }.not_to raise_error }
  end
  
  describe ".get_stored_past_third_party_ids" do
    before(:each) do
      allow(Event).to receive_message_chain(:where, :each_with_object).and_return([])
    end
    let(:action) { Event.get_stored_past_third_party_ids }
    it { expect{ action }.not_to raise_error }
  end
  
   describe ".store_third_party_events" do
    before(:each) do
      allow(Event).to receive(:process_remote_events)
      allow(Event).to receive(:get_remote_events)
    end
    let(:action) { Event.store_third_party_events({}) }
    it { expect{ action }.not_to raise_error }
  end
  
  describe "#get_remote_rsvps" do
    before(:each) do
      allow(Meetup).to receive_message_chain(:new, :pull_rsvps)
    end
    let(:event_obj) { create(:event) }
    it { expect{ event_obj.get_remote_rsvps }.not_to raise_error }
  end
end
