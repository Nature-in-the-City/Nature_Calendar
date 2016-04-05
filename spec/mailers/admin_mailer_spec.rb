require 'rails_helper'
require 'spec_helper'

describe AdminMailer, type: :mailer do
    
    describe "#admin_email" do
        let(:test_event) { create(:event) }
        let(:test_guest) { create(:guest) }
        let(:default_email) { "info@natureinthecity.org" }
        let(:mail) { AdminMailer.admin_email(test_guest, test_event) }
        it "should send mail to 'info@natureinthecity.org'" do
            expect(mail.to).to eql([default_email])
        end
        it "should send mail from 'info@natureinthecity.org'" do
            expect(mail.from).to eql([default_email])
        end
        it "should have the subject 'RSVP for ?'" do
            expect(mail.subject).to eql("RSVP for #{test_event.name}")
        end
    end
end