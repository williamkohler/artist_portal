require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  def setup
    @contact = contacts(:bill)
    @invalid_contact = contacts(:invalid_contact)
    @venue = venues(:sinclair)
  end

  test 'contact should be valid' do
    assert @contact.valid?
  end

  test 'contact should be invalid without email' do
    assert_not @invalid_contact.valid?
  end

  test 'contact venue relationship should be destroyed' do
    @contact.connect @venue
    assert @contact.venues.include? @venue
    @contact.save
    assert_difference 'ContactVenueRelationship.count', -1 do
      @contact.destroy
    end
    assert_not @venue.contacts.include? @contact
  end
end
