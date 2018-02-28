class AddStageAndStartDateToShows < ActiveRecord::Migration[5.1]
  def change
    add_column :shows, :deal_stage, :string
    add_column :shows, :start_date, :datetime
  end
end
