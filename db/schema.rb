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

ActiveRecord::Schema[7.2].define(version: 2025_02_14_182204) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "cube"
  enable_extension "earthdistance"
  enable_extension "plpgsql"

  create_table "properties", id: :serial, force: :cascade do |t|
    t.string "offer_type"
    t.string "property_type"
    t.string "zip_code", null: false
    t.string "city", null: false
    t.string "street"
    t.string "house_number"
    t.decimal "lng", precision: 11, scale: 8
    t.decimal "lat", precision: 11, scale: 8
    t.integer "construction_year"
    t.decimal "number_of_rooms", precision: 15, scale: 2
    t.string "currency"
    t.decimal "price", precision: 15, scale: 2
    t.index "ll_to_earth((lat)::double precision, (lng)::double precision)", name: "index_properties_on_lat_lng_gist", using: :gist
  end
end
