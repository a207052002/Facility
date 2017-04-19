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

ActiveRecord::Schema.define(version: 20170413083743) do

  create_table "facilities", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "facilities_users", force: :cascade do |t|
    t.integer "facility_id"
    t.integer "user_id"
    t.index ["facility_id"], name: "index_facilities_users_on_facility_id"
    t.index ["user_id"], name: "index_facilities_users_on_user_id"
  end

  create_table "use_times", force: :cascade do |t|
    t.string   "period"
    t.datetime "day"
    t.datetime "created_at"
    t.string   "user_id"
    t.string   "description"
    t.integer  "facility_id"
    t.index ["facility_id"], name: "index_use_times_on_facility_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "role",                   default: "normal", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
