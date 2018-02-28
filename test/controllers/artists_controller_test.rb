require 'test_helper'
class ArtistsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @standard_user = users(:standard)
    @admin = users(:admin)
    @other_user = users(:other)
    @radiohead = artists(:radiohead)
  end

  test 'should add an artist' do
    log_in_as(@standard_user)
    assert_not @standard_user.admin
    assert_difference 'Artist.count', 1 do
      post artists_path params: { artist: { name: 'test Artist',
                                            website:
                                           'http://www.example.com' } }
    end
  end

  test 'only an admin should delete an artist' do
    # Standard user can't delete an artist.
    log_in_as(@standard_user)
    assert_not @standard_user.admin
    assert_no_difference 'Artist.count' do
      delete artist_path(@radiohead)
    end
    # Admin user can delete an artist.
    log_in_as(@admin)
    assert @admin.admin
    assert_difference 'Artist.count', -1 do
      delete artist_path(@radiohead)
    end
  end
end
