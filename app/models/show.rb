class Show < ApplicationRecord
  require 'csv'
  require 'date'
  default_scope { order(start_date: :asc) }
  belongs_to :artist
  validates :agent,           presence: true
  validates :backend,         presence: true
  validates :capacity,        presence: true
  validates :contract_due,    presence: true
  validates :fee,             presence: true,
                              numericality: { greater_than: -1 }
  validates :gross_potential, presence: true
  validates :number_of_shows, presence: true,
                              numericality: { only_integer: true,
                                              greater_than: 0 }
  validates :set_length,      presence: true
  validates :start_date,      presence: true
  validates :start_time,      presence: true
  validates :ticket_scale,    presence: true
  validates :venue_id,        presence: true
  validates :promoter_id,     presence: true
  validates :production_id,   presence: true


  # The venue for the show.
  def venue
    Venue.find(venue_id)
  end

  # The promoter for the show.
  def promoter
    Contact.find(promoter_id)
  end

  # The production for the show.
  def production
    Contact.find(promoter_id)
  end

  # Find a hubspot contact by it's email.
  def hubspot_contact(email)
    Hubspot::Contact.find_by_email email
  end

  # Translates a hubspot date.
  def self.read_hubspot_date(date)
    if date.nil?
      nil
    else
      ii = date.to_i
      time = Time.at(ii / 1000).utc
      date = time.to_date
    end
  end

  # Find a hub deal by it's 'deal_id'.
  def self.find_hubspot_deal(deal_id)
    Hubspot::Deal.find deal_id
  rescue Hubspot::RequestError
    Show.find_by(deal_id: deal_id).destroy
  end

  # Reads the hubspot csv file. Can look up 'Artist' & 'Deal ID'.
  def self.hubspot_csv
    csv_text = File.read('app/assets/csv/hubspot.csv')
    CSV.parse(csv_text, headers: true)
  end

  # Return an array of artist names from hubspot.
  def self.hubspot_artists
    artists = Array new
    csv_text = File.read('app/assets/csv/hubspot.csv')
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      artists << row['Artist'] unless artists.include? row['Artist']
    end
    artists.shift # removes the headers
    artists.sort_by(&:downcase)
  end

  # Creates shows from an imported csv file.
  def self.import(file)
    file_name = file.path
    text = File.read(file_name, encoding: 'UTF-8')
    saved_shows = []
    unsaved_shows = []
    shows = {}
    csv = CSV.parse(text, headers: true, header_converters: :symbol)
    csv.each do |row|
      show = Show.new
      show.deal_id = row[:deal_id]
      show.artist = row[:artist]
      show.artist_id = Artist.find_by(name: row[:artist]).id
      # show.deal_stage = row[:deal_stage]
      show.start_date = row[:start_date]
      begin
        if show.save
          saved_shows << show
        else
          unsaved_shows << show
        end
      rescue
        puts "csv deal creation error: #{$ERROR_INFO}"
        unsaved_shows << show
      end
    end
    shows[:saved] = saved_shows
    shows[:unsaved] = unsaved_shows
    shows
  end

  # Shows that are from hubspot.
  def self.hubspot_db_records
    Show.where(from_hubspot: true)
  end

  # Returns an array of all hubspot shows for an artist.
  def self.get_hubspot_shows(artist)
    issued = '323905d1-2784-4fc5-b4bd-d544348f2668'
    today = Time.zone.now
    hubspot_shows = []
    db_records = Show.where(artist: artist).to_a
    db_records.sort_by!(&:start_date) # sort by start date
    db_records.each do |record|
      next unless today <= record.start_date
      show = find_hubspot_deal record[:deal_id]
      hubspot_shows << show if show[:dealstage] == issued
    end
    hubspot_shows
  end

  # Get an artist's hubspot shows for a specified month.
  def self.hubspot_month_shows(artist, date)
    hubspot_shows = []
    # Get shows from the database
    first = date.beginning_of_month
    last = date.end_of_month
    db_records = Show.where(start_date: first..last, artist: artist).to_a
    # sort database db_records
    db_records.sort_by!(&:start_date)
    db_records.each do |record|
      hubspot_shows << find_hubspot_deal(record[:deal_id])
    end
    hubspot_shows
  end

  # Get all the shows for an artist in a month as a hash.
  # The start dates are the keys
  def self.shows_in_month_hash(artist, date)
    first = date.beginning_of_month
    last = date.end_of_month
    shows = Show.where(start_date: first..last, artist_id: artist.id)
    shows.group_by(&:start_date)
  end

  # Get all shows for an artist in a month.
  def self.shows_in_month(artist, date)
    first = date.beginning_of_month
    last = date.end_of_month
    Show.where(start_date: first..last, artist_id: artist.id)
  end

  # Checks if a shows's deposit is overdue.
  def self.deposit_overdue?(show)
    answer = false
    if show[:deposit_due]
      deposit_due_date = read_hubspot_date show[:deposit_due]
      if show[:date_deposit_received].nil?
        answer = true if Date.today > deposit_due_date
      end
  end
    answer
  end

  # Finds an agents based on the hubspot id.
  def self.hubspot_owner(hub_id)
    agent = Agent.find_by(hubspot_id: hub_id)
    if agent
      agent.name
    else
      hub_id
    end
  end

  # Check to make sure a hubspot show is issued.
  def self.confirmed_hubspot_check(shows)
    issued = '323905d1-2784-4fc5-b4bd-d544348f2668'
    today = Time.now.utc
    shows.each do |show|
      puts show[:dealname] if show[:dealstage] != issued
    end
  end
end
