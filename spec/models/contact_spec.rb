require 'rails_helper'
require 'spec_helper'

describe Contact, type: :model do
    
  describe 'instance creation' do
    before(:each) do
      @args_all = {name_first: "Lana", name_last: "Kane", email: "lana@kane.gov", phone: "(555) 555-5555", website: "fxnetworks.com"}
    end
    
    context 'when valid arguments supplied' do
      it 'should be valid with all arguments' do
        model_all = Contact.create(@args_all)
        expect(model_all).to be_valid
      end
      
      it 'should be valid with just email' do
        model_only_email = Contact.create(:email => "sterling@archer.com")
        expect(model_only_email).to be_valid
      end
    end
    
    context 'when invalid arguments are supplied' do
      it 'should be invalid when email is not supplied' do
        @args_all[:email] = nil
        model_no_email = Contact.create(@args_all)
        expect(model_no_email).not_to be_valid
      end
            
      it 'should be invalid when email is invalid' do
        invalid_emails = ["lksterling.com", "lk!sterling.com", "lk@sterlingcom", "lk@sterling.cim"]
        invalid_emails.each do |address|
          invalid = Contact.create(:email => address)
          expect(invalid).not_to be_valid
        end
      end
    end
  end
  
  describe "#format_name" do
      context "when first and last name are provided" do
          
      end
      
      context "when only first name is proivided" do
      end
      
      context "when only last name is provided" do
      end
      
      context "when no name is provided" do
      end
  end
end