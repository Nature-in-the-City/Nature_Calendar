require 'spec_helper'
require 'rails_helper'

describe SyncsController do
    before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:render)
    end
    
    describe "GET #show" do
        it { expect{ post :show, { id: 10 } }.not_to raise_error }
    end
    
    describe "GET #new" do
        let(:new_sync) { get :new }
        it { expect{ new_sync }.not_to raise_error }
    end
    
    describe "POST #create" do
        context "when google cal is added" do
            before(:each) { post :create, sync: { organization: "Nature", url: "google.com/somefunurl" } }
            it { expect(assigns(flash[:notice])).to be_nil }
        end
        context "when Meetup cal is added" do
            before(:each) { post :create, sync: { organization: "Nature", url: "meetup.com/somefunurl" } }
            it { expect(assigns(flash[:notice])).to be_nil }
        end
        context "when invalid cal is added" do
            before(:each) { post :create, sync: { organization: "Nature", url: "invalid.com/somefunurl" } }
            it { expect(assigns(flash[:notice])).to be_nil }
        end
    end
    
    describe "#update" do
        it { expect{ put :update, { id: 10 } }.not_to raise_error }
        
    end
    
    describe "#destroy" do
        it { expect{ delete :destroy, { id: 10 } }.not_to raise_error }
    end

end