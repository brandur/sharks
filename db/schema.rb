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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110801060029) do

  create_table "incidents", :force => true do |t|
    t.string   "case_id"
    t.date     "occurred_on"
    t.string   "occurred_on_str"
    t.float    "lat"
    t.float    "lng"
    t.string   "full_address"
    t.string   "country"
    t.string   "area"
    t.string   "location"
    t.string   "activity"
    t.string   "name"
    t.string   "sex"
    t.integer  "age"
    t.string   "injury"
    t.boolean  "is_fatal"
    t.boolean  "is_provoked"
    t.string   "time_of_day"
    t.string   "species"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "incidents", ["lat", "lng"], :name => "index_incidents_on_lat_and_lng"

end
