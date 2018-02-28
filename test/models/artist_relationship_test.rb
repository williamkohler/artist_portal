require 'test_helper'

class ArtistRelationshipTest < ActiveSupport::TestCase
  def setup
    @artist_relationship = ArtistRelationship.new(user_id: users(:bill).id,
                                                  artist_id: artists(:james).id)
  end

  test 'should be valid' do
    assert @artist_relationship.valid?
  end
end
