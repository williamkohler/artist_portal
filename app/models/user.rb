class User < ApplicationRecord
  has_many :artist_relationship
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  default_scope -> { order(name: :asc) }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\- ]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns true for a standard user, false otherwise.
  def standard_user
    !admin
  end

  # Checks if an artist is assigned to a user.
  def artist_assigned?(artist)
    assigned_artists.include? artist
  end

  class << self
  # Returns the hash digest of the given string.
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Search for a user.
  def search(search)
    if Rails.env.development?
      query ='name like ?'
    else
      query = 'name ilike ?'
    end
    User.where(query, "%#{search}%")
  end

  # Returns a random token.
  def new_token
    SecureRandom.urlsafe_base64
  end
end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgest a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends an activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Assign an artist to a user.
  def assign(artist)
    artist_relationship.create(artist_id: artist.id,
                               user_id: id)
  end

  # Unassign an artist to a user.
  def unassign(artist)
    relationship = ArtistRelationship.where(artist_id: artist.id,
                                            user_id: id)
    artist_relationship.delete relationship
  end

  # Returns assigned artists
  def assigned_artists
    artists = []
    artist_relationship.each do |relationship|
      artist = Artist.find(relationship.artist_id)
      artists << artist
    end
    artists.sort_by &:name
  end

  # First attempt at returning unassigned artists (keep for later testing)
  def unassigned_artists_v1
    ids = []
    assigned_artists.each do |artist|
      ids << artist.id
    end
    Artist.where.not(id: ids)
  end

  # Returns unassigned_artists
  def unassigned_artists
    unassigned = []
    Artist.all.each do |artist|
      unassigned << artist if assigned_artists.exclude? artist
    end
    unassigned.sort_by &:name
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
