## app/models/venue.rb
class Venue < ApplicationRecord
  has_many :contact_venue_relationships, dependent: :destroy
  has_many :contacts, through: :contact_venue_relationships
  validates :name, presence: true, length: { maximum: 100 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :street_address, presence: true
  validates :country, presence: true, length: { maximum: 100 }
  validates :capacity, presence: true, numericality: { greater_than: 0,
                                                       only_integer: true }
  validates :website, format: URI.regexp(%w[http https])
  validates :website, url: true
  default_scope -> { order(name: :asc) }
  before_save :downcase_website

  # Search for a venue by name.
  def self.search(search)
    if Rails.env.development?
      query ='name like ?'
    else
      query = 'name ilike ?'
    end
    Venue.where(query, "%#{search}%")
  end

  # Shows that occur at the venue.
  def shows
    Show.where(venue_id: id)
  end

  # Returns a formatted address.
  def address
    if city && state_region
      "#{street_address} #{city}, #{state_region}"
    else
      "#{street_address} #{city}, #{country}"
    end
  end

  # The venue address without street
  def simple_address
    if city && state_region
      "#{city}, #{state_region}"
    else
      "#{city}, #{country}"
    end
  end

  # A contact's name & email
  def summary
    "#{name} (#{simple_address})"
  end

# The contacts that are not connected to venue.
def unconnected_contacts
  unconnected = []
  Contact.all.each do |contact|
    unconnected << contact if contacts.exclude? contact
  end
  return unconnected
end

  # Connects a venue and a contact.
  def connect(contact)
    ContactVenueRelationship.create(contact_id: contact.id,
                                    venue_id: id)
  end

  # Unconnects a venue and a contact.
  def unconnect(contact)
    relationship = ContactVenueRelationship.find_by(venue_id: id,
                                                    contact_id: contact.id)
    relationship.destroy
  end
end
