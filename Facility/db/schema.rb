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

ActiveRecord::Schema.define(version: 20170411075802) do

  create_table "allow_users", force: :cascade do |t|
    t.string  "portal_id"
    t.integer "facility_id"
    t.index ["facility_id"], name: "index_allow_users_on_facility_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string  "name",                        null: false
    t.string  "description",                 null: false
    t.boolean "membership",  default: false, null: false
    t.boolean "verify",      default: false, null: false
    t.string  "board"
  end

  create_table "facilities_users", force: :cascade do |t|
    t.integer "facility_id"
    t.integer "user_id"
    t.index ["facility_id"], name: "index_facilities_users_on_facility_id"
    t.index ["user_id"], name: "index_facilities_users_on_user_id"
  end

  create_table "large_rent", force: :cascade do |t|
    t.string   "period",  null: false
    t.datetime "day",     null: false
    t.integer  "month",   null: false
    t.integer  "rent_id"
    t.index ["rent_id"], name: "index_large_rent_on_rent_id"
  end

  create_table "rents", force: :cascade do |t|
    t.string   "period",                      null: false
    t.datetime "day",                         null: false
    t.datetime "created_at"
    t.string   "description", default: "",    null: false
    t.integer  "facility_id"
    t.string   "user_id",                     null: false
    t.boolean  "verified",    default: false
    t.boolean  "large",       default: false
    t.index ["facility_id"], name: "index_rents_on_facility_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "portal_id", null: false
  end

end
