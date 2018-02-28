class CreateVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :venue_type
      t.string :street_address
      t.string :city
      t.string :state_region
      t.string :postal_code
      t.string :country
      t.integer :capacity
      t.string :website

      t.timestamps
    end
  end
end
