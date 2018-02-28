module ApplicationHelper
  require 'net/http'
  include ActionView::Helpers::NumberHelper
  require 'json'

  def full_title(page_title = '')
    base_title = 'Artist Portal'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  # Returns a hash of the top five top_songs for an artist
  # Key is the name of the song
  # Value is the last.fm url
  def artist_top_tracks(artist)
    api_key = ENV.fetch('LAST_FM_API_KEY')
    url = 'http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&'\
          'artist=#{artist}&api_key=#{api_key}&format=json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    top_songs = {}
    5.times do |n|
      top_songs[json['toptracks']['track'][n]['name']] =
        json['toptracks']['track'][n]['url']
    end
    top_songs
  end

  # Get's a user's top albums for the current week.
  def weekly_albums(user)
    key = ENV.fetch('LAST_FM_API_KEY')
    url = 'http://ws.audioscrobbler.com/2.0/?method=user.getweeklyalbumchart&'\
    'user=#{user}&api_key=#{key}&format=json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  # Top fifty albums for a last.fm user.
  def top_albums(user)
    key = ENV.fetch('LAST_FM_API_KEY')
    url = 'http://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&'\
    'user=#{user}&api_key=#{key}&format=json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
