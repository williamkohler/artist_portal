class ContactVenueRelationship < ApplicationRecord
  belongs_to :contact
  belongs_to :venue
  validates :contact_id, presence: true
  validates :venue_id, presence: true
end
