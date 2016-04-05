# spec/factories/event.rb

FactoryGirl.define do
    factory :event do
        name 'A default event'
        organization 'FunTimes'
        description 'A fun event!'
        url 'www.coolstuff.com'
        start { 10.days.from_now }
        #end  { 11.days.from_now } --> causing errors!!
        how_to_find_us 'send us an email'
        meetup_id 21211
        status 'approved'
        contact_first "Factory"
        contact_last "Girl"
        contact_email "contact@email.com"
        contact_phone "858-555-1551"
        venue_name 'A house'
        st_number 7400
        st_name 'Vista Del Mar Ave'
        city 'La Jolla'
        zip 92037
        country 'USA'
        free true
        family_friendly true
        learn true
        plant true
    end
end

