class CreateShows < ActiveRecord::Migration[5.1]
  def change
    create_table :shows do |t|
      t.integer :deal_id
      t.string :artist

      t.timestamps
    end
    add_index :shows, [:deal_id]
  end
end
