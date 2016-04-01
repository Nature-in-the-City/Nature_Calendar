require 'rails_helper'

describe AdminMailer, type: :mailer do
    
    describe "#admin_email" do
        it "should send mail to 'info@natureinthecity.org'"
        it "should have the subject 'RSVP for ?'"
    end
end