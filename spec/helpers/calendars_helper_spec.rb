require 'rails_helper'
require 'spec_helper'

describe CalendarsHelper, type: :helper do
  before(:each) do
      @head, @body = WebScraper.instance.page_data
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(create(:user))
      allow_any_instance_of(ApplicationController).to receive(:render)
  end
  describe "#process_body" do
      before(:each) do
          allow_any_instance_of(CalendarsHelper).to receive(:replace_wrapper)
          allow_any_instance_of(CalendarsHelper).to receive(:insert_calendar)
          allow_any_instance_of(CalendarsHelper).to receive(:link_social_icons)
          allow_any_instance_of(CalendarsHelper).to receive(:absolutize_links)
          allow_any_instance_of(CalendarsHelper).to receive(:remove_scripts)
          allow_any_instance_of(CalendarsHelper).to receive(:replace_image)
          allow_any_instance_of(CalendarsHelper).to receive(:process_head)
          @action = lambda{ helper.process_body(@body) }
      end
      it { expect{ @action.call }.not_to raise_error }
  end
  
  describe "#replace_wrapper" do
      let(:action) { helper.replace_wrapper(@body) }
      it { expect{ action }.not_to raise_error }
  end
  
  describe "#insert_calendar" do
      before(:each) {allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(create(:user))}
      let(:action) { helper.insert_calendar(@body) }
      it { expect{ action }.not_to raise_error }
  end
    
  describe "#replace_image" do
      let(:action) { helper.replace_wrapper(@body) }
      before(:each) do
          #allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(create(:user))
          allow_any_instance_of(ApplicationController).to receive(:render)
      end
      it { expect{ action }.not_to raise_error }
  end
    
  describe "#link_social_icons" do
  end
  
  describe "#absolutize_links" do
  end

  describe "#absolutize_collection" do
  end

  describe "#process_head" do
  end

  describe "#remove_scripts" do
  end
end