class CreateContactVenueRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_venue_relationships do |t|
      t.integer :contact_id
      t.integer :venue_id
      t.timestamps
    end
    add_index :contact_venue_relationships, :contact_id
    add_index :contact_venue_relationships, :venue_id
    # Makes sure contacts and venues can't be related more than once.
    add_index :contact_venue_relationships, [:contact_id, :venue_id],
              unique: true
  end
end
