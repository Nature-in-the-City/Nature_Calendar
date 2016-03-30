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

  describe '#new' do
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
    end
  end
  describe '#edit' do
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
end
