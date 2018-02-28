class CreateArtistRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :artist_relationships do |t|
      t.integer :artist_id
      t.integer :user_id

      t.timestamps
    end
    add_index :artist_relationships, :artist_id
    add_index :artist_relationships, :user_id
    # Makes sure a user can't relate to an artist more than once.
    add_index :artist_relationships, [:artist_id, :user_id], unique: true
  end
end
