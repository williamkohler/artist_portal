# Contact
class Contact < ApplicationRecord
  has_many :contact_venue_relationships, dependent: :destroy
  has_many :venues, through: :contact_venue_relationships
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\- ]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  default_scope -> { order(name: :asc) }
  before_save :downcase_email

  def self.search(search)
    Contact.where('name like ?', "%#{search}%")
  end

  # A contact's name & email
  def summary
    "#{name} (#{email})"
  end

  # All the shows where the contact is the promoter.
  def promoter_shows
    Show.where(promoter_id: id)
  end

  # Connect a venue to the contact.
  def connect(venue)
    ContactVenueRelationship.create(contact_id: id,
                                    venue_id: venue.id)
  end

  # Unconnects the contact and a venue.
  def unconnect
    relationship = ContactVenueRelationship.find_by(contact_id: id,
                                                    venue_id: venue.id)
    relationship.destroy
  end

  # The venues that are not connected to the contact.
  def unconnected_venues
    unconnected = []
    Venue.all.each do |venue|
      unconnected << venue if venues.exclude? venue
    end
    return unconnected
  end

  private

  def downcase_email
    email.downcase!
  end
end
