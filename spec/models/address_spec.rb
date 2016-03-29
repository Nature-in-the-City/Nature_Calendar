require 'rails_helper'

describe Address, :type => :model do
    before(:each) do
        @valid_no_suite = Address.new(st_number: 1211, st_name: "Montgomery Street", city: "San Francisco", state: "CA", zip: 94133)
        @valid_suite = Address.new(st_number: 1211, st_name: "Montgomery Street", apt_suite: 1000, city: "San Francisco", state: "CA", zip: 94133)
    end
    
    describe 'instance creation' do
        before(:each) do
            @args = {st_number: 1211, st_name: "Montgomery Street", apt_suite: 1000, city: "San Francisco", state: "CA", zip: 94133}
        end
        
        context 'valid creation arguments' do
            it 'is valid with zip and without city or state' do
                @args[:city] = nil
                @args[:state] = nil
                model = Address.create(@args)
                expect(model).to be_valid
            end
            
            it 'is valid without apartment or suite number' do
                @args[:apt_suite] = nil
                model_no_suite = Address.create(@args)
                expect(model_no_suite.to be_valid)
            end
            
            it 'is valid with all attributes' do
                model = Address.create(@args)
                expect(model).to be_valid
            end
        end
        
        context 'invalid creation arguments' do
            it 'is invalid without street number' do
                @args[:st_number] = nil
                model = Address.create(@args)
                expect(model).not_to be_valid
            end
            it 'is invalid without street name' do
                @args[:st_name] = nil
                model = Address.create(@args)
                expect(model).not_to be_valid
            end
            it 'is invalid without city, state or zip' do
                @args[:zip] = nil
                @args[:state] = nil
                @args[:city] = nil
                model = Address.create(@args)
                expect(model).not_to be_valid
            end
        end
    end
    
    describe '#in_radius?' do
        it 'should call zip API'
        
        context 'when in radius' do
            it "is_expected.to respond_with true" do
                expect(answer).to be_truthy
                answer = @valid_no_suite.in_radius? 94132, 5
            end
        end
        
        context 'when not in radius' do
            it "is_expected.to respond_with false" do
                expect(answer).to be_falsey
                answer = @valid_suite.in_radius? 92115, 15
            end
        end
    end
    
    describe '#full_address' do
        it 'should call #street_address' do
            expect(@valid_no_suite).to receive(:street_address)
            @valid_no_suite.full_address
        end
        
        it 'should call #city_state_zip' do
            expect(@valid_suite).to receive(:city_state_zip)
            @valid_suite.full_address
        end
        
        context 'when address is valid' do
            it 'should be formatted correctly' do
                resp_value = @valid_no_suite.full_address
                expect(resp_value).to eql("1211 Montgomery Street, San Francisco, CA 94133")
            end
        end
    end
    
    describe '#street_address' do
        context 'when street address is valid' do
            let(:rval) { @valid_no_suite.street_addres }
            
            it 'should return the correct address' do
                expect(rval).to contain_exactly("1211", "Montgomery", "Street")
            end
            
            it 'should be formatted correctly' do
                expect(return_value).to eql("1211 Montgomery Street")
            end
        end
        
        context 'when there is an apartment or suite number' do
            let(:response_value) { @valid_suite.street_address }
            
            it 'should return the correct apt number' do
                expect(response_value).to include("1000")
            end
            
            it 'should be formatted correctly' do
                expect(response_val).to eql("1211 Montgomery Street #1000")
            end
        end
        
        context 'when there is not an apartment or suite number' do
            let(:rval) { @valid_no_suite.street_address }
            
            it 'should not have any trailing whitespace' do
                expect(rval).to end_with("t")
            end
            
            it 'should be formatted correctly'do
                expect(rval).to eql("1211 Montgomery Street")
            end
        end
    end
    
    describe '#city_state_zip' do
        context 'when the city, state or zip is valid' do
            let(:resp) { @valid_no_suite.city_state_zip }
            
            it 'should return the correct values' do
                expect(resp).to contain_exactly("San", "Francisco,", "CA", "94133")
            end
            
            it 'should be formatted correctly' do
                expect(resp).to eql("San Francisco, CA 94133")
            end
        end
    end
end
