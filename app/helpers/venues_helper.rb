module VenuesHelper
  def venue_icon
    image_tag('venue-icon', alt: 'venue icon', class: 'album')
  end
end
