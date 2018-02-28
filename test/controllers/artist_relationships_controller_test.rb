require 'test_helper'

class ArtistRelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bill)
    @artist = artists(:radiohead)
  end

  test 'should assign artist' do
    assert_not @user.assigned_artists.include? @artist
    @user.assign @artist
    assert @user.assigned_artists.include? @artist
  end

  test 'should unassign artist' do
    @user.assign @artist
    assert @user.assigned_artists.include? @artist
    @user.unassign @artist
    assert_not @user.assigned_artists.include? @artist
  end

  test 'should assign artist via web' do
    assert_not @user.assigned_artists.include? @artist
    assert_difference '@user.assigned_artists.count', 1 do
      post artist_relationships_path, params: { user_id:   @user.id,
                                                artist_id: @artist.id }
      @user.reload
    end
  end

  test 'should unassign artist via web' do
    relationship = ArtistRelationship.create!(artist_id: @artist.id,
                                              user_id: @user.id)
    assert_difference 'ArtistRelationship.count', -1 do
      delete artist_relationship_path(relationship)
    end
  end
end
