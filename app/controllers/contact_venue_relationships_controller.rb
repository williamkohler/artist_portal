# ContactVenueRelationshipsController
class ContactVenueRelationshipsController < ApplicationController
  before_action :build_relationship, only: :create
  def create
    if @relationship.save
      flash[:success] = "#{@contact.name} and #{@venue.name} connected."
    else
      flash[:danger] = "#{@contact.name} and #{@venue.name} already connected."
    end
    redirect_back(fallback_location: root_url)
  end

  def destroy
    @relationship = ContactVenueRelationship.find(params[:id])
    @contact = Contact.find(@relationship[:contact_id])
    @venue = Venue.find(@relationship[:venue_id])
    @relationship.destroy
    flash[:warning] = "#{@contact.name} and #{@venue.name} are"\
    ' no longer connected.'
    redirect_back(fallback_location: root_url)
  end

  private


  def relationship_params
    params.require(:relationship).permit(:contact_id, :venue_id)
  end

  # Before filters

  def build_relationship
    @contact = Contact.find(relationship_params[:contact_id])
    @venue = Venue.find(relationship_params[:venue_id])
    @relationship = ContactVenueRelationship.new(contact_id: @contact.id,
                                                 venue_id: @venue.id)
  end
end
