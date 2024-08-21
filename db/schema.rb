# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_19_215251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "polling_locations", force: :cascade do |t|
    t.string "title", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "postal_code", null: false
    t.bigint "riding_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["riding_id"], name: "index_polling_locations_on_riding_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "number", null: false
    t.bigint "riding_id", null: false
    t.bigint "polling_location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["polling_location_id"], name: "index_polls_on_polling_location_id"
    t.index ["riding_id"], name: "index_polls_on_riding_id"
  end

  create_table "ridings", force: :cascade do |t|
    t.string "name", null: false
    t.string "riding_code", null: false
    t.string "province", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "polling_locations", "ridings"
  add_foreign_key "polls", "polling_locations"
  add_foreign_key "polls", "ridings"
end
