class UpdateShow < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :deal_stage
    add_column :shows, :venue_id, :integer
    add_column :shows, :promoter_id, :integer
    add_column :shows, :production_id, :integer
  end
end
