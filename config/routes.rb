Rails.application.routes.draw do
  resource :calendar, only: [:show]
  root 'calendars#show'

  devise_for :users, skip: [:registrations]

  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users/:id' => 'devise/registrations#update', as: 'user_registration'
  end

  resources :events do
    collection do
      get 'third_party'
      post 'third_party'
      post 'pull_third_party'
    end
  end
  
  resources :guests, only: [:new, :create]

  resources :accounts
  
  resources :syncs
end
