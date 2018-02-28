class AddToArtistModel < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :contact_name, :string
    add_column :artists, :contact_phone, :string
    add_column :artists, :contact_email, :string
    add_column :artists, :website, :string
  end
end
