# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160401072230) do

  create_table "events", force: :cascade do |t|
    t.string   "name",                                                                    null: false
    t.string   "organization"
    t.text     "description"
    t.string   "url"
    t.decimal  "cost",                       precision: 15, scale: 2, default: 0.0
    t.datetime "start",                                                                   null: false
    t.datetime "end"
    t.text     "how_to_find_us"
    t.integer  "meetup_id"
    t.string   "status",                                              default: "pending"
    t.datetime "updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_first"
    t.string   "contact_last"
    t.string   "contact_email"
    t.string   "contact_phone",   limit: 16
    t.string   "venue_name"
    t.integer  "st_number"
    t.string   "st_name"
    t.string   "city"
    t.integer  "zip"
    t.string   "state",           limit: 2,                           default: "CA"
    t.string   "country",                                             default: "USA"
    t.boolean  "free",                                                default: false
    t.boolean  "family_friendly",                                     default: false
    t.boolean  "hike",                                                default: false
    t.boolean  "play",                                                default: false
    t.boolean  "learn",                                               default: false
    t.boolean  "volunteer",                                           default: false
    t.boolean  "plant",                                               default: false
  end

  create_table "guests", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.boolean  "is_anon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "guest_id"
    t.datetime "updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "syncs", force: :cascade do |t|
    t.string   "organization"
    t.string   "url"
    t.datetime "last_sync"
    t.integer  "calendar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                               null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.integer  "level",                  default: 0,  null: false
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
