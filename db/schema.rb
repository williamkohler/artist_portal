# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180222165444) do

  create_table "artist_relationships", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id", "user_id"], name: "index_artist_relationships_on_artist_id_and_user_id", unique: true
    t.index ["artist_id"], name: "index_artist_relationships_on_artist_id"
    t.index ["user_id"], name: "index_artist_relationships_on_user_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "from_hubspot", default: false
    t.string "contact_name"
    t.string "contact_phone"
    t.string "contact_email"
    t.string "website"
    t.index ["slug"], name: "index_artists_on_slug"
  end

  create_table "contact_venue_relationships", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id", "venue_id"], name: "index_contact_venue_relationships_on_contact_id_and_venue_id", unique: true
    t.index ["contact_id"], name: "index_contact_venue_relationships_on_contact_id"
    t.index ["venue_id"], name: "index_contact_venue_relationships_on_venue_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "job_title"
    t.string "phone"
    t.string "mobile"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "shows", force: :cascade do |t|
    t.integer "deal_id"
    t.string "artist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "artist_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "from_hubspot", default: false
    t.integer "fee"
    t.string "hotel"
    t.string "ground"
    t.string "backline"
    t.string "venue_name"
    t.string "start_time"
    t.string "set_length"
    t.integer "number_of_shows"
    t.string "agent"
    t.string "contract_number"
    t.datetime "contract_due"
    t.datetime "contract_signed_by_promoter"
    t.datetime "contract_signed_by_artist"
    t.datetime "deposit_due_date"
    t.integer "deposit_amount_due"
    t.integer "deposit_amount_received"
    t.datetime "deposit_received_date"
    t.string "ticket_scale"
    t.string "capacity"
    t.string "gross_potential"
    t.datetime "on_sale"
    t.datetime "announce"
    t.string "backend"
    t.integer "venue_id"
    t.integer "promoter_id"
    t.integer "production_id"
    t.index ["deal_id"], name: "index_shows_on_deal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "venue_type"
    t.string "street_address"
    t.string "city"
    t.string "state_region"
    t.string "postal_code"
    t.string "country"
    t.integer "capacity"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
