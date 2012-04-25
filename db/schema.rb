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

ActiveRecord::Schema.define(:version => 20120425193735) do

  create_table "candidates", :force => true do |t|
    t.string   "name"
    t.string   "party"
    t.integer  "race_id"
    t.decimal  "cache_percentage", :precision => 5, :scale => 2
    t.integer  "cache_votes"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "elections", :force => true do |t|
    t.date     "date",                           :null => false
    t.integer  "type_id",                        :null => false
    t.integer  "status_id",                      :null => false
    t.boolean  "party_split", :default => false, :null => false
    t.boolean  "lock",        :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "elections", ["date"], :name => "index_elections_on_date", :unique => true

  create_table "precincts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "precincts_races", :id => false, :force => true do |t|
    t.integer "precinct_id"
    t.integer "race_id"
  end

  create_table "races", :force => true do |t|
    t.string   "name"
    t.string   "imported_as"
    t.string   "instructions"
    t.integer  "election_id"
    t.string   "cache_precincts_reporting"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "statuses", ["value"], :name => "index_statuses_on_value", :unique => true

  create_table "types", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "types", ["value"], :name => "index_types_on_value", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "number"
    t.integer  "candidate_id"
    t.integer  "precinct_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
