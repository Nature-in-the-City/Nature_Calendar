require 'spec_helper'
require 'rails_helper'

describe Venue do
    before(:each) do
        allow(Meetup).to receive_message_chain(:new, :get_venues)
    end
    
    describe ".get_new_meetup_venue_id" do
    end
end