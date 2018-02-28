class AddBackendToShows < ActiveRecord::Migration[5.1]
  def change
    add_column :shows, :backend, :string
  end
end
