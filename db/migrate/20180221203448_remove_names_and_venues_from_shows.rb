class RemoveNamesAndVenuesFromShows < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :venue_city
    remove_column :shows, :venue_st
    remove_column :shows, :venue_country
    remove_column :shows, :promoter_name
    remove_column :shows, :promoter_phone
    remove_column :shows, :promoter_email
    remove_column :shows, :production_name
    remove_column :shows, :production_phone
    remove_column :shows, :production_email
  end
end
