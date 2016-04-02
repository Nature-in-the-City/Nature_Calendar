# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db
# with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

events = [{ name: 'Market Street Prototyping Festival',
            organization: 'Nature in the City',
            description: 'A walk through the city',
            venue_name: 'The Old Town Hall',
            st_number: 145, st_name: 'Jackson st',
            city: 'Glendale',
            zip: 90210,
            contact_email: 'nature@walk.com',
            free: true,
            family_friendly: true,
            hike: true,
            start: 'March 09 2016 11:00',
            end: 'March 19 2016, 20:30',
            how_to_find_us: 'First door on left',
            meetup_id: 122121212,
            status: 'approved' },
          { name: 'Nerds on Safari: Market Street',
            organization: 'Green Carrots',
            description: "If you like beans you'll like this event!",
            venue_name: 'San Francisco City Library',
            st_number: 45,
            st_name: 'Seneca st',
            city: 'Phoenix',
            zip: 91210,
            contact_email: 'nerds1@safari.com',
            free: false,
            cost: 15.0,
            family_friendly: true,
            learn: true,
            start: 'April 11 2016 00:00',
            end: 'April 21 2016, 8:30',
            how_to_find_us: 'Second door on the left',
            meetup_id: 656555556,
            status: 'approved' },
          { name: 'Muir Woods Hike',
            organization: 'Outdoorsy',
            description: 'Come hike the iconic Muir woods of Mill Valley!',
            venue_name: 'Muir Woods',
            st_number: 1,
            st_name: 'Muir Woods Rd',
            city: 'Mill Valley',
            zip: 94941,
            free: true,
            family_friendly: true,
            hike: true,
            contact_email: 'events2@outdoorsy.com',
            start: 'March 27 2016 09:00 AM',
            end: 'March 27 2016, 03:30 PM',
            how_to_find_us: 'Meet in parking lot at 9 AM',
            meetup_id: 656555557,
            status: 'pending' },
          { name: 'Bay to Breakers',
            organization: 'Zappos.com',
            description: 'Bay2Breakers is a 12K that has run for over 100 years',
            venue_name: 'SF!',
            st_number: 318,
            st_name: 'Main st',
            city: 'San Francisco',
            zip: 94105,
            contact_email: 'info1@zapposbaytobreakers.com',
            free: false,
            cost: 50.00,
            family_friendly: false,
            start: 'May 15 2016 06:00',
            end: 'May 25 2016, 12:30',
            how_to_find_us: 'Pier 35',
            meetup_id: 656555558,
            status: 'rejected' }
  ]

guests = [{ first_name: 'Bob',
            last_name: 'Richard',
            phone: '(851) 345-0987',
            email: 'brichard12@gmail.com',
            address: '234 Greensburg',
            is_anon: 'False' }
  ]

registrations = [{ event_id: 1, guest_id: 1 }]

users = [{ email: 'admin123@admin.com',
           password: 'password',
           level: 0,
           reset_password_token: 'token' }
  ]
  
syncs = [{ organization: 'Nature in the City',
           url: 'http://www.meetup.com/Nature-in-the-City/',
           last_sync: 'May 15 2016 06:00',
           calendar_id: 656555558 }
        ]

events.each do |event|
  Event.create!(event)
end

guests.each do |guest|
  Guest.create!(guest)
end

registrations.each do |registration|
  Registration.create!(registration)
end

users.each do |user|
  User.create!(user)
end

syncs.each do |sync|
  Sync.create!(sync)
end
