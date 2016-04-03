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
    it 'can be accessed by root' do
      sign_in @root
      get :new
      expect(response).to render_template(:new)
    end
    
    it 'cannot be accessed by non-root admin' do
      sign_in @admin
      get :new
      expect(response).to redirect_to(calendar_path)
    end
    
    it 'cannot be accessed by guest' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:notice]).to match(/^You must be root admin to access this action/)
    end
  end
  
  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }
    
    context 'when given valid params' do
      before(:each) do
        sign_in @root
        @valid_params = {email: "jon@doe.edu", password: "password", reset_password_token: "token"}
        @usr = User.new(@valid_params)
        #allow(User).to receive(:save).with(@valid_params).and_return(@usr)
      end
      
      it 'creates a new user' do
        expect(User).to receive(:new).with(@valid_params)
        expect(User).to receive(:save)
        expect{ post :create, session: @valid_params }.to change{User.count}.by(1)
      end
      it 'saves the user'
      it 'redirects to calendar_path'
      it 'renders the view with a success message'
    end
    
    context 'when given invalid params' do
      before(:each) do
        sign_in @root
        @user = double()
        @user.stub(:save) { false }
        User.stub(:new).and_return(@user)
        post :create, user: {email: nil, password: "password"}
      end
      it 'redirects to new_account_path' do
        expect(response).to redirect_to new_account_path
      end
      it 'renders a view with an error message' do
        expect(flash[:notice]).not_to be_nil
      end
    end
  end
  
  describe 'GET #edit' do
    it 'can be accessed by root' do
      sign_in @root
      get :edit, id: 'root'
      expect(response).to render_template(:edit)
    end
    it 'cannot be accessed by non-root admin' do
      sign_in @admin
      get :edit, id: 'root'
      expect(response).to redirect_to(calendar_path)
    end
    it 'cannot be accessed by guest' do
      get :edit, id: 'root'
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  
  describe 'DELETE #destroy' do
    before(:each) do
      sign_in @root
      allow(User).to receive(:find_by_id)
    end
    
    context 'when the account being destroyed does not exist' do
      it 'should search for the account' do
        expect(User).to receive(:find_by_id).with("100")
        delete :destroy, { id: 100 }
      end
      it 'should redirect_to calendar with an error message' do
        delete :destroy, { id: 100 }
        expect(response).to redirect_to '/calendar'
        expect(flash[:notice]).to match(/^Account does not exist/)
      end
    end
    
    context 'when the account being destroyed does exist' do
      before(:each) do
        @test_user = User.create!(email: "destroy@example.com", password: "password")
        allow(User).to receive(:find_by_id).and_return(@test_user)
      end
      it 'should find the right account and delete it' do
        expect(User).to receive(:find_by_id).with("3").and_return(@test_user)
        expect{ delete :destroy, { id: 3 } }.to change{User.count}.by(-1)
      end
      it 'should redirect_to calendar with a success message' do
        delete :destroy, { id: 3 }
        expect(response).to redirect_to '/calendar'
        expect(flash[:notice]).to match(/^destroy@example.com deleted/)
      end
    end
  end
end
