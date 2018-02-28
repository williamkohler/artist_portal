class VenuesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :logged_in_user
  before_action :admin_user, only: :destroy

  def index
    if params[:search]
      @venues = (Venue.search params[:search]).paginate(page: 1)
    else
      @venues = Venue.all.paginate(page: params[:page], per_page: 20)
    end
  end

  def show
    @venue = Venue.find(params[:id])
    @capacity = number_with_delimiter(@venue.capacity)
    @contacts = @venue.contacts
    @shows = @venue.shows
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      flash[:success] = "#{@venue.name} successfully created."
      redirect_to venues_path
    else
      flash[:warning] = 'Unable to create venue.'
      render 'new'
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(venue_params)
      flash[:success] = "#{@venue.name} updated."
      redirect_to venues_path
    else
      render 'edit'
    end
  end

  def destroy
    venue = Venue.find(params[:id])
    flash[:success] = "#{venue.name} deleted."
    venue.destroy
    redirect_to venues_path
  end

  def shows
    @venue = Venue.find(params[:id])
    @shows = @venue.shows.paginate(page: params[:page], per_page: 10)
  end

  private

  def venue_params
    params.require(:venue).permit!
  end
end
