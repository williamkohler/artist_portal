require 'test_helper'

class ContactVenueRelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @venue = venues(:sinclair)
    @contact = contacts(:bill)
    @user = users(:admin)
end

  test 'should connect contact and venue via the web' do
    log_in_as(@user)
    get venue_path(@venue)
    assert_not @contact.venues.include? @venue
    assert_difference 'ContactVenueRelationship.count', 1 do
      post contact_venue_relationships_path params:
      { relationship: { contact_id: @contact.id, venue_id: @venue.id } }
    end
    assert @contact.venues.include? @venue
  end

  test 'should un-connect contact and venue via the web' do

    relationship = ContactVenueRelationship.create!(venue_id: @venue.id,
                                                    contact_id: @contact.id)
    assert_difference 'ContactVenueRelationship.count', -1 do
      delete contact_venue_relationship_path relationship
    end
  end
end
