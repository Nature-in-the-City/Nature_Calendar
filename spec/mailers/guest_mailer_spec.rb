require 'spec_helper'
require 'rails_helper'

describe GuestMailer, type: :mailer do
    
    describe "#rsvp_email" do
        let(:default_email) { "info@natureinthecity.org" }
        let(:test_guest) { Guest.new(email: "guest@mailer.gov") }
        let(:test_event) { Event.new(name: "Hike", start: 1.day.from_now, end: 2.days.from_now) }
        let(:mail) { GuestMailer.rsvp_email(test_guest, test_event) }
        it 'should not raise an error' do
            expect{ mail }.not_to raise_error
        end
        it "should set the 'to' field" do
            expect(mail.to).to eql([test_guest.email])
        end
        it "mail should be from 'info@natureinthecity.org'" do
            expect(mail.from).to eql([default_email])
        end
        it "should have subject 'RSVP for HIKE'" do
            expect(mail.subject).to eql("RSVP for #{test_event.name}")
        end
    end
end