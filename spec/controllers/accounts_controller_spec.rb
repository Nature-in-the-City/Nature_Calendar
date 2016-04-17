require 'rails_helper'
require 'spec_helper'

describe AccountsController do
  before(:each) do
    @root = User.create(email: "root@root.com",
                        password: "password",
                        level: 0)
    @admin = User.create(email: "example@example.com",
                         password: "password")
  end
  after(:each) do
    sign_out(@admin)
    sign_out(@root)
  end

  describe 'GET #new' do
    let(:action) { get :new }
    it 'can be accessed by root' do
      sign_in @root
      expect(action).to render_template(:new)
    end
    it 'can be accessed by non-root admin' do
      sign_in @admin
      expect(action).not_to redirect_to(calendar_path)
    end
    it 'cannot be accessed by guest' do
      expect(action).to redirect_to(calendar_path)
      expect(flash[:notice]).to match(/^You must be root admin to access this action/)
    end
  end
  
  describe 'POST #create' do
    before(:each) do
      sign_in @root
    end
    context 'when given valid params' do
      let(:valid_creation) { post :create, user: { email: "jon@doe.edu", password: "password", reset_password_token: "token", level: 1 } }
      it 'should redirect to calendar_path with success message' do
        expect(valid_creation).to redirect_to calendar_path
        expect(flash[:notice]).to eql("jon@doe.edu successfully created!")
      end
    end
    context 'when given invalid params' do
      let(:invalid_user) { User.new }
      let(:invalid_creation) { post :create, user: { email: nil, password: "password" } }
      before(:each) do
        allow(User).to receive(:new).and_return(invalid_user)
        allow(invalid_user).to receive(:save).and_return(false)
      end
      it 'should redirect to new_account_path with failure message' do
        expect(invalid_creation).to redirect_to new_account_path
        expect(flash[:notice]).not_to be_nil
      end
    end
  end
  
  describe 'GET #edit' do
    let(:edit_action) { get :edit, id: 1 }
    
    before(:each) do
      sign_in @root
    end
    after(:each) do
      sign_out @root
    end
    
    context "when no non-admin users exist" do
      it 'should render edit page with flash' do
        expect(edit_action).to render_template(:edit)
        expect(flash[:notice]).not_to be_nil
      end
    end
    context "when one non-admin exists" do
      before do
        User.create!(email: "user@user.com", password: "password", level: "1", reset_password_token: "token")
      end
      it { expect(edit_action).to render_template(:edit) }
    end
    context "when there are no users" do
      before(:each) do
        allow(User).to receive(:all).and_return(User.none)
      end
      it "should set flash" do
        expect{ edit_action }.not_to raise_error
        expect(flash.now[:notice]).not_to be_nil
      end
    end
  end
  
  describe 'DELETE #destroy' do
    before(:each) do
      sign_in @root
    end
    
    context 'when the account being destroyed does not exist' do
      let(:destroy_100) { delete :destroy, { id: 100 } }
      
      before do
        allow(User).to receive(:find_by_id)
      end
      it 'should redirect and display failure message' do
        expect(destroy_100).to redirect_to calendar_path
        expect(flash[:notice]).to eql("Account does not exist")
      end
    end
    context 'when the account being destroyed does exist' do
      let(:destroy_3) { delete :destroy, { id: 3 } }
      
      before(:each) do
        @test_user = User.create!(email: "destroy@example.com", password: "password")
        allow(User).to receive(:find_by_id).and_return(@test_user)
      end
      it 'should find the right account and delete it' do
        expect(User).to receive(:find_by_id).with("3").and_return(@test_user)
        expect{ destroy_3 }.to change{ User.count }.by(-1)
      end
      it 'should redirect_to calendar with a success message' do
        expect(destroy_3).to redirect_to calendar_path
        expect(flash[:notice]).to match(/^destroy@example.com deleted/)
      end
    end
  end
  
  describe 'PATCH/PUT #update' do
    before(:each) do
      @basic_account = create(:user, email: 'user@example.com')
      @second_account = create(:user, email: 'user2@example.com', level: 1)
      @account_id = @basic_account.id
      @second_id = @second_account.id
    end
    let(:patch_event) { patch :update, id: @account_id }
    let(:put_event) { put :update, id: @second_id }
    
    before(:each) do
      sign_in @root
    end
    
    context "when using 'put' or patch" do
      it 'should not error' do
        expect{ put_event }.not_to raise_error
        expect{ patch_event }.not_to raise_error
      end
    end
  end
  
end
