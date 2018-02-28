require 'test_helper'

class ArtistTest < ActiveSupport::TestCase

  def setup
    @artist = artists(:radiohead)
    @contact = contacts(:bill)
    @venue = venues(:sinclair)
  end

  test 'artist should be valid' do
    test_artist = Artist.new(name: 'New Artist',
                             website: 'http://www.example.com')
    assert test_artist.valid?
  end

  test 'associated shows should be destroyed' do
    assert_difference 'Show.count', -1 do
      @artist.destroy
    end
  end

  test "should get an artist's top five albums" do
    required_keys = %w[name playcount mbid url artist image]
    top_albums = @artist.top_albums
    assert top_albums.class == Array
    assert top_albums.count == 5
    required_keys.each do |key|
      assert top_albums[0].include? key
    end
  end

  test 'should search and find artist' do
    assert_equal @artist, Artist.find(@artist.id)
  end
end
