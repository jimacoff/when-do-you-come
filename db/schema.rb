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

ActiveRecord::Schema.define(version: 20131115220346) do

  create_table "positions", force: true do |t|
    t.integer  "total_km"
    t.integer  "remaining_km"
    t.datetime "a_timestamp"
    t.integer  "remaining_time"
    t.decimal  "a_poi_lat"
    t.decimal  "a_poi_lng"
    t.decimal  "b_poi_lat"
    t.decimal  "b_poi_lng"
    t.decimal  "actual_poi_lat"
    t.decimal  "actual_poi_lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
