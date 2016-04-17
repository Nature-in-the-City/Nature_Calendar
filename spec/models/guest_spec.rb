require 'rails_helper'

describe Guest do

  describe "::parse_meetup_name" do
    context "with a name including both first and last" do
      let(:good_name) {'Chester Copperpot'}

      it "returns both first and last" do
      result = Guest::parse_meetup_name(good_name)
      expect(result).to eq(['Chester', 'Copperpot'])
      end
    end

    context "with a name with no distinct first and last" do
      let(:bad_name) {'Chester'}

      it "returns the first and an empty last" do
      result = Guest::parse_meetup_name(bad_name)
      expect(result).to eq(['Chester', ''])
      end
    end
  end

  describe "#all_non_anon" do
    let(:guest1) {Guest.new(is_anon: true)}
    let(:guest2) {Guest.new(is_anon: false)}

    before(:each) do
      guest1.save!
      guest2.save!
    end

    it "returns those guests who are not anon" do
      result = guest1.all_non_anon
      expect(result.first).to eq(guest2)
    end
  end

  describe "#all_anon" do
    let(:guest1) {Guest.new(is_anon: true)}
    let(:guest2) {Guest.new(is_anon: false)}

    before(:each) do
      guest1.save!
      guest2.save!
    end

    it "returns those guests who are anon" do
      result = guest1.all_anon
      expect(result.first).to eq(guest1)
    end
  end
  
  describe ".find_by_meetup_rsvp" do
    
    let(:rsvp_basic) { { meetup_id: 121121 } }
    let(:basic_event) { create(:event, meetup_id: 121121) }
    
    before(:each) do
      allow(Event).to receive(:find_by_meetup_id).and_return(basic_event)
    end
    
    it 'should not throw and error' do
      expect{ Guest.find_by_meetup_rsvp(rsvp_basic) }.not_to raise_error
    end
  end
  
  describe ".create_by_meetup_rsvp" do
    let(:rsvp_basic) { { meetup_name: "Nature In The City",  meetup_id: 121121 } }
    let(:create_action) { Guest.create_by_meetup_rsvp(rsvp_basic) }
    before(:each) do
      allow(Guest).to receive(:parse_meetup_name).and_return("Armando", "Fox")
    end
    it 'should not throw an error' do
      expect{ create_action }.not_to raise_error
    end
    it "should create a guest with the name 'Armando'" do
      create_action
      expect(Guest.where("first_name = ?", 'Armondo')).not_to be_nil
    end
  end
end
