## app/controllers/artists_controller.rb
class ArtistsController < ApplicationController
  include ShowsHelper
  include ArtistsHelper
  include ActionView::Helpers::NumberHelper
  before_action :logged_in_user,              only: :index
  before_action :admin_user,                  only: %i[destroy]
  before_action :approved_artists,            only: :index
  before_action :artist_show_variables,       only: :show

  def index
    if params[:search]
      @artists = Artist.search(params[:search])
    else
      @artists = Artist.all.paginate(page: params[:page], per_page: 18)
    end
  end

  def new
    @artist = Artist.new
  end

  def show
    hubspot_or_standard_artists
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      flash[:success] = "Created #{params[:artist][:name]}."
    else
      flash[:danger] = "Unable to add #{params[:artist][:name]}"
    end
    redirect_to artists_path
  end

  def edit
    @artist = Artist.find_by(slug: params[:id])
  end

  def update
    @artist = Artist.find_by(slug: params[:id])
    if @artist.update_attributes(artist_params)
      flash[:success] = "#{@artist.name} updated."
      redirect_to artist_path @artist
    else
      render 'edit'
    end
  end

  def destroy
    artist = Artist.find_by(slug: params[:id])
    flash[:info] = "#{artist.name} deleted"
    artist.destroy
    redirect_to artists_path
  end

  def artist_params
    params.require(:artist).permit!
  end

  # Search for an artist
  def standard_user_artist_search(artist_name, user)
    artists = Artist.search artist_name
    approved_artists = []
    artists.each do |artist|
      approved_artists << artist if user.assigned_artists.include?(artist)
    end
    approved_artists
  end

  # Search with assigned artists
  def approved_artist_search(artist_name)
    artists = if current_user.admin?
                Artist.search artist_name
              else
                standard_user_artist_search artist_name, current_user
              end
    artists.paginate(page: params[:page], per_page: 18)
  end

  private

  # Sets the variables for a hubspot or standard artist
  def hubspot_or_standard_artists
    if current_artist.from_hubspot?
      @shows = Show.hubspot_month_shows(@artist.name, @date)
      @sorted_shows = @shows.group_by do |d|
        read_date d[:start_date]
      end
    else
      @shows_hash = Show.shows_in_month_hash(@artist, @date)
      @shows = Show.shows_in_month(@artist, @date)
    end
  end

  # Before filters

  # Provides the approved artists for a user
  def approved_artists
    if current_user.admin?
      # Switch for hubspot vs standard artists
      test_artists = Artist.where(from_hubspot: false)
      @artists = test_artists.paginate(page: params[:page],
                                       per_page: 18)
    else
      @artists = current_user.assigned_artists
    end
    @artists
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  # Confirms a a user is either an admin or assigned to an artist.
  def approved_user
    return if current_user.admin? ||
              (current_user.artist_assigned? current_artist)
    flash[:warning] = "#{current_user.name} is not assigned to artist "\
                      "#{current_artist.name}."
    redirect_to(user_path(current_user))
  end

  # Sets the variables for the artist 'show' action.
  def artist_show_variables
    @user = current_user
    @artist = Artist.find_by(slug: params[:id])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @count = @artist.upcoming_count
    @cal_selection = params[:cal]
  end
end
