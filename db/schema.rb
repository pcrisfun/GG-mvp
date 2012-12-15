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

ActiveRecord::Schema.define(:version => 20121112212521) do

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "state",                                              :default => "started"
    t.string   "title"
    t.string   "topic"
    t.string   "host"
    t.text     "description"
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.integer  "hours"
    t.string   "hours_per",                                          :default => "week"
    t.string   "availability"
    t.string   "location_address"
    t.string   "location_address2"
    t.string   "location_city"
    t.string   "location_state"
    t.string   "location_zipcode"
    t.boolean  "location_private"
    t.boolean  "location_varies"
    t.integer  "age_min"
    t.integer  "age_max"
    t.integer  "registration_min"
    t.integer  "registration_max"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.string   "charge_id"
    t.datetime "regsitration_ends_at"
    t.string   "kind"
    t.string   "other_needs"
    t.decimal  "price",                :precision => 8, :scale => 2
    t.datetime "registration_ends_at"
    t.date     "begins_at_date"
    t.time     "begins_at_time"
    t.date     "ends_at_date"
    t.time     "ends_at_time"
    t.string   "location_nbrhood"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
