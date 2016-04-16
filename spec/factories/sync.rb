# spec/factories/sync.rb

FactoryGirl.define do
    factory :sync do
        organization 'Nature in the City'
        url 'http://www.meetup.com/Natre-in-the-City/'
        last_sync 'May 15 2016 06:00'
        calendar_id 656555558
    end
end