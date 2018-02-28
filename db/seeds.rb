# Users
User.create!(name: 'Bill Kohler',
             email: 'bkohler4@gmail.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'Admin User',
             email: 'admin@example.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'Standard User',
             email: 'user@example.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'Anna Sala',
             email: 'anna@example.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name = Faker::GameOfThrones.character
  password = 'foobar'
  User.create!(name: name,
               email: "example#{n+1}@dragonmail.com",
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Artists
artist_file = 'app/assets/csv/artists.csv'
Artist.saved_artist_names(artist_file).each do |artist|
  Artist.create!(name: artist,
                website: "http://www.#{artist.delete(' ').downcase}.com")
end



# Standard Artist Relationships
admin_user = User.find_by(email: 'admin@example.com')
standard_user = User.find_by(email: 'user@example.com')
1.upto(6) do |n|
  admin_user.assign(Artist.find(n))
  standard_user.assign(Artist.find(n + 3))
end

developer_user = User.find_by(email: 'bkohler4@gmail.com')
developer_user.assign(Artist.find_by(name: 'Beach House'))
developer_user.assign(Artist.find_by(name: 'James Blake'))
developer_user.assign(Artist.find_by(name: 'Portishead'))
developer_user.assign(Artist.find_by(name: 'Radiohead'))
developer_user.assign(Artist.find_by(name: 'Sade'))
developer_user.assign(Artist.find_by(name: 'Baroness'))


User.all.each do |user|
  6.times do
    artist = Artist.find(rand(1..Artist.count))
    user.assign(artist) if user.assigned_artists.exclude?(artist)
  end
end

# Contacts
job_title_array = ['Talent Buyer', 'Manager', 'Publicist']
20.times do |n|
  Contact.create!(name: Faker::TwinPeaks.character,
                  job_title: job_title_array.sample,
                  phone: Faker::PhoneNumber.cell_phone,
                  mobile: Faker::PhoneNumber.cell_phone,
                  email: "contact#{n + 1}@thelodge.com")
end

# Venues
venue_type_array = ['Club', 'Concert Hall', 'Outdoor']
50.times do |n|
  venue = Faker::TwinPeaks.location
  Venue.create!(name: venue,
                venue_type: venue_type_array.sample,
                street_address: Faker::Address.street_address,
                city: Faker::Address.city,
                state_region: Faker::Address.state_abbr,
                postal_code: Faker::Address.postcode,
                country: 'US',
                capacity: rand(100..1200),
                website: "http://www.example-#{n+1}.com")
end

# Contact Venue Relationships
Contact.all.each do |contact|
  3.times do
    venue = Venue.find(rand(1..Venue.count))
    contact.connect(venue) if contact.venues.exclude?(venue)
  end
end

# Shows
ground_array = ['all local ground transportion provided',
                'airport transfers only', 'buyout', 'n/a']
backline_array = ['per artist rider', 'in-house backline', 'other', 'n/a']
hotel_array = ['one hotel room', 'two hotel roooms for two nights', 'n/a']
backend_array = ['flat guarantee', 'vs 80% of gross box office receipts',
                 'plus a $1,000.00 bonus at sellout']
start_time_array = %w[7:00pm 8:00pm 9:00pm 9:30pm 10:00pm]
set_length_array = ['seventy-five to ninety minutes',
                    'two forty-five minute sets', 'ninety minutes']
start_date_array = [1, 1, 1, 2, 3, 18]
contract_number = 1000
Artist.all.each do |artist|
  start_date = Date.today
  40.times do |n|
    ii = rand(1000..20_000)
    fee = (ii + 50) / 100 * 100
    cc = rand(300..1200)
    capacity = cc + 50 / 100 * 100
    agent = Faker::TwinPeaks.character
    artist.shows.create!(start_date: start_date,
                         venue_id: Venue.find(rand(1..Venue.count)).id,
                         fee: fee,
                         backend: backend_array.sample,
                         hotel: hotel_array.sample,
                         ground: ground_array.sample,
                         backline: backline_array.sample,
                         start_time: start_time_array.sample,
                         set_length: set_length_array.sample,
                         number_of_shows: 1,
                         agent: agent,
                         contract_number: contract_number,
                         contract_due: start_date - 90,
                         deposit_due_date: start_date - 90,
                         deposit_amount_due: fee / 2,
                         ticket_scale: 'tbd',
                         capacity: capacity,
                         gross_potential: 'tbd',
                         on_sale: start_date - 70,
                         announce: start_date - 80,
                         promoter_id: Contact.find(rand(1..Contact.count)).id,
                         production_id: Contact.find(rand(1..Contact.count)).id)
    contract_number += 1
    start_date += start_date_array.sample
  end
end
