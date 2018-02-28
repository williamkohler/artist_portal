require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  def setup
    @venue = venues(:sinclair)
    @international_venue = venues(:international_venue)
    @contact = contacts(:bill)
  end

  test 'venue should be valid' do
    venue = Venue.new(name: 'The Sinclair',
                      street_address: '52 Church Street',
                      city: 'Boston',
                      country: 'US',
                      capacity: '500',
                      website: 'http://www.sinclaircambridge.com')
    assert venue.valid?
  end

  test 'venue should have a capacity greater than 0' do
    venue = Venue.new(name: 'The Sinclair',
                      city: 'Boston',
                      country: 'US',
                      capacity: '0')
    assert_not venue.valid?
  end

  test 'should format address with city & state' do
    assert_equal '52 Church Street Boston, MA', @venue.address
  end

  test 'should format address with city & country' do
    assert_equal 'Bennelong Point Sydney, Australia',
                 @international_venue.address
  end

  test 'contact venue relationship should be destroyed' do
    @venue.connect @contact
    assert @venue.contacts.include? @contact
    @venue.save
    assert_difference 'ContactVenueRelationship.count', -1 do
      @venue.destroy
    end
    assert_not @contact.venues.include? @venue
  end
end
