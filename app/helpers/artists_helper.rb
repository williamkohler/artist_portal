module ArtistsHelper
  # Size can be 1 - 4
  def album_for(artist, options = { size: 1 })
    size = options[:size]

    if size == 3
      album_art = 'luke-chesser-large'
    elsif size == 2
      album_art = 'luke-chesser-medium'
    elsif size == 1
      album_art = 'luke-chesser-small'
    else
      raise 'StandardError'
    end
    if artist.top_albums.empty?
      return image_tag(album_art, alt: artist.name, class: 'album')
    else
      url = artist.top_albums[0]['image'][size]['#text']
      if url.empty?
        image_tag(album_art, alt: artist.name, class: 'album')
      else
        image_tag(url, alt: artist.name, class: 'album')
      end
      end
    end

  def current_artist
    if (slug = params[:id])
      @current_artist ||= Artist.find_by(slug: slug)
    end
  end
end
