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

ActiveRecord::Schema.define(version: 20190910214106) do

  create_table "logs", force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "organization_id"
    t.string  "clock_in",        default: "0:0"
    t.string  "clock_out",       default: "0:0"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password"
    t.string "state"
    t.string "city"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "organization_id"
    t.string  "review"
    t.integer "rating",          default: 0
  end

  create_table "volunteers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "password"
  end

end
