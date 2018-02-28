class ArtistRelationship < ApplicationRecord
  belongs_to :user
  validates :artist_id, presence: true
  validates :user_id, presence: true
end
