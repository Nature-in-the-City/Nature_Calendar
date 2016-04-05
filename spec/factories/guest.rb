# spec/factories/guest.rb

FactoryGirl.define do
    factory :guest do
        first_name "Jon"
        last_name "Doe"
        phone "555-555-5555"
        email "jon@doe.edu"
        address "1211 Street Ave"
        is_anon false
    end
end