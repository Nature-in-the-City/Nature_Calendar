# spec/factories/user.rb

FactoryGirl.define do
    factory :user do
        email 'jon@doe.edu' #default email value
        password 'password'
        reset_password_token 'token'
        level 0
    end
end
        