## app/controllers/artist_relationships_controller.rb
class ArtistRelationshipsController < ApplicationController
  before_action :build_relationship, only: :create

  def create
    if @relationship.save
      flash[:success] = "#{@artist.name} assigned to #{@user.name}."
    else
      flash[:danger] = 'Relationship already exists'
    end
    redirect_to @user
  end

  def destroy
    @relationship = ArtistRelationship.find(params[:id])
    @artist = Artist.find(@relationship[:artist_id])
    @user = User.find(@relationship[:user_id])
    @relationship.destroy
    flash[:warning] = "#{@artist.name} removed from #{@user.name}."
    redirect_to @user
  end

  private

  def artist_relationship_params
    params.require(:artist_relationship).permit(:artist_id, :user_id)
  end

  # Before filters

  def build_relationship
    @relationship = ArtistRelationship.new(artist_id: params[:artist_id],
                                           user_id: params[:user_id])
    @artist = Artist.find(params[:artist_id])
    @user = User.find(params[:user_id])
  end
end
