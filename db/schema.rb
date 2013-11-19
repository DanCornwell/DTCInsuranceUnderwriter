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

ActiveRecord::Schema.define(version: 20131118191905) do

  create_table "people", force: true do |t|
    t.integer  "quotation_id"
    t.string   "title"
    t.string   "forename"
    t.string   "surname"
    t.string   "email"
    t.date     "dob"
    t.string   "telephone"
    t.string   "street"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "license_type"
    t.integer  "license_period"
    t.string   "occupation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_incidents"
  end

  add_index "people", ["email"], name: "index_people_on_email"

  create_table "policies", force: true do |t|
    t.integer  "excess"
    t.string   "breakdown_cover"
    t.string   "windscreen_cover"
    t.integer  "quotation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotations", force: true do |t|
    t.integer  "premium"
    t.date     "calculation_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  add_index "quotations", ["code"], name: "index_quotations_on_code", unique: true

  create_table "vehicles", force: true do |t|
    t.string   "registration"
    t.integer  "mileage"
    t.integer  "estimated_value"
    t.string   "parking"
    t.date     "start_date"
    t.integer  "quotation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
