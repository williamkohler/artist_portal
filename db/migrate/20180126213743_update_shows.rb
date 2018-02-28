class UpdateShows < ActiveRecord::Migration[5.1]
  def change
    add_column :shows, :end_date, :datetime

    # HubSpot Shows
    add_column :shows, :from_hubspot, :boolean, default: false

    # Compensation
    add_column :shows, :fee, :integer
    add_column :shows, :hotel, :string
    add_column :shows, :ground, :string
    add_column :shows, :backline, :string

    # Venue
    add_column :shows, :venue_name, :string
    add_column :shows, :venue_city, :string
    add_column :shows, :venue_st, :string
    add_column :shows, :venue_country, :string

    # Engagement Information
    add_column :shows, :start_time, :string
    add_column :shows, :set_length, :string
    add_column :shows, :number_of_shows, :integer

    # Contract
    add_column :shows, :agent, :string
    add_column :shows, :contract_number, :string
    add_column :shows, :contract_due, :datetime
    add_column :shows, :contract_signed_by_promoter, :datetime
    add_column :shows, :contract_signed_by_artist, :datetime

    # Deposit
    add_column :shows, :deposit_due_date, :datetime
    add_column :shows, :deposit_amount_due, :integer
    add_column :shows, :deposit_amount_received, :integer
    add_column :shows, :deposit_received_date, :datetime

    # Ticket Information
    add_column :shows, :ticket_scale, :string
    add_column :shows, :capacity, :string
    add_column :shows, :gross_potential, :string

    # Announce / On sale
    add_column :shows, :on_sale, :datetime
    add_column :shows, :announce, :datetime

    # Promoter Contact
    add_column :shows, :promoter_name, :string
    add_column :shows, :promoter_phone, :string
    add_column :shows, :promoter_email, :string

    # Production Contact
    add_column :shows, :production_name, :string
    add_column :shows, :production_phone, :string
    add_column :shows, :production_email, :string
  end
end
