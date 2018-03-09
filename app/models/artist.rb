# Artist
class Artist < ApplicationRecord
  require 'net/http'
  require 'json'

  has_many :shows, dependent: :destroy
  default_scope -> { order(name: :asc) }
  validates :name, presence: true, length: { maximum: 100 }
  validates :name, uniqueness: { case_sensitive: false }
  extend FriendlyId
  friendly_id :name, use: [:slugged]
  validates :website, format: URI.regexp(%w[http https])
  validates :website, url: true
  before_save :downcase_website

  class << self
    # Artists that are not from hubspot.
    def standard_artists
      Artist.where(from_hubspot: false)
    end

    # Artists that are from hubspot.
    def hubspot_artists
      Artist.where(from_hubspot: true)
    end

    # Reads in artists names.
    def saved_artist_names(filename)
      names = []
      csv_text = File.read filename
      csv = CSV.parse(csv_text)
      csv.each do |row|
        names << row[0]
      end
      names
    end

    # Search for an artist by name.
    def search(search)
      if Rails.env.development?
        query ='name like ?'
      else
        query = 'name ilike ?'
      end
      Artist.where(query, "%#{search}%")
    end

    # Returns a hash of the roster's top songs.
    # Key is the artist name / value is the song name.
    def roster_top_songs
      songs = {}
      Artist.all.each do |artist|
        begin
          song = artist.top_song_names[0]
          songs[artist.name] = song
        rescue URI::InvalidURIError
          puts "Unable to retrieve song for #{artist.name}"
        rescue NoMethodError
          puts "'NoMethodError' for #{artist.name}"
        end
      end
      songs
    end
  end

  # Top five tracks for an artist. Keys are song names / values are url's.
  def top_tracks
    key = ENV.fetch('LAST_FM_API_KEY')
    url = 'http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks'\
          "&artist=#{name}&api_key=#{key}&format=json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  # The names of an artists top five last.fm tracks.
  def top_song_names
    tracks = top_tracks
    names = []
    5.times do |n|
      names << tracks['toptracks']['track'][n]['name']
    end
    names
  end

  # An artist's top albums from last.fm.
  def top_albums
    key = ENV.fetch('LAST_FM_API_KEY')
    url = 'http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums'\
    "&artist=#{name}&api_key=#{key}&limit=5&format=json"
    uri = URI.parse(URI.escape(url))
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)

    if json['error'] == 6
      puts "no json for: #{name}"
      return []

    else
      json['topalbums']['album']
    end
  end

  # Count of upcoming shows (after today) for an artist.
  def upcoming_count
    count = 0
    all_shows = Show.where(artist_id: id)
    all_shows.each do |show|
      if show.start_date >= Date.today
        puts show.start_date
        count += 1
      end
    end
    count
  end
end
