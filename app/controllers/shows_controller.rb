## app/controllers/shows_controller.rb
class ShowsController < ApplicationController
  before_action :form_collections, only: %i[new edit]
  before_action :admin_user, only: :destroy

  def new
    @show = Show.new
  end

  # TODO: fix create action
  def create
    @artist = Artist.find(show_params[:artist_id])
    @show = @artist.shows.build(show_params)
    if @show.save
      flash[:success] = 'Show created.'
      redirect_to artist_path @artist
    else
      @artists = Artist.all
      flash[:warning] = 'Unable to create show.'
      render 'new'
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def edit
    @show = Show.find(params[:id])
    @artist = Artist.find(@show.artist_id)
    @artists = Artist.all
  end

  def update
    @show = Show.find(params[:id])
    @artist = Artist.find(@show.artist_id)
    if @show.update_attributes(show_params)
      flash[:success] = 'Show updated.'
      redirect_to @artist
    else
      render 'edit'
    end
  end

  def destroy
    show = Show.find(params[:id])
    artist = Artist.find(show.artist_id)
    flash[:success] = "#{artist.name} at #{show.venue_name} deleted."
    show.destroy
    redirect_to artist
  end

  private

  def show_params
    params.require(:show).permit!
  end

  # Finds an artist.
  def find_artist
    return if Artist.find_by(name: show_params[:artist])
    "#{show_params[:artist]} not found"
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  # Before filters

  # Values for form drop downs
  def form_collections
    @artists = Artist.all
    @venues = Venue.all
    @contacts = Contact.all
  end
end
