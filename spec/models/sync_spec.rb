require 'rails_helper'
require 'spec_helper'

describe Sync, type: :model do
    let(:basic_sync) { create(:sync, last_sync: 1.day.ago) }
    it 'should not throw an error when created' do
        expect{ basic_sync }.not_to raise_error
    end
    
    describe "#needs_syncing" do
        it 'should return true when current > last_sync' do
            expect(basic_sync.needs_syncing? DateTime.now).to be_truthy
        end
    end
end