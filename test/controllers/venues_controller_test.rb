require 'test_helper'

class VenuesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @standard_user = users(:standard)
    @venue = venues(:sinclair)
  end

  test 'users should be able to visit venue index pages' do
    # Admin user
    log_in_as @admin
    get venues_path
    assert_response :success
    get edit_venue_path @venue
    assert_response :success
    get new_venue_path
    assert_response :success
    # Standard User
    log_in_as @standard_user
    get venues_path
    assert_response :success
    get edit_venue_path @venue
    assert_response :success
    get new_venue_path
    assert_response :success
  end

  test 'only admin users should be able to delete venues' do
    log_in_as @admin
    assert_difference 'Venue.count', -1 do
      delete venue_path @venue
    end
    log_in_as @standard_user
    assert_no_difference 'Venue.count', -1 do
      delete venue_path @venue
    end
  end

  test 'users should be able to create venues' do
    log_in_as @admin
    get new_show_path
    assert_difference 'Venue.count', 1 do
      post venues_path params: { venue: { name: 'New Venue',
                                          city: 'Boston',
                                          street_address: '1 Street Address',
                                          country: 'US',
                                          capacity: 500,
                                          website: 'http://www.example.com' } }
    end
    log_in_as @standard_user
    assert_difference 'Venue.count', 1 do
      post venues_path params: { venue: { name: 'New Venue',
                                          city: 'Boston',
                                          street_address: '1 Street Address',
                                          country: 'US',
                                          capacity: 500,
                                          website: 'http://www.example.com' } }
    end
  end
end
