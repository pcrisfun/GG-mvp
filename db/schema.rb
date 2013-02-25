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

ActiveRecord::Schema.define(:version => 20130224222802) do

  create_table "admins", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "gallery_id"
  end

  create_table "albums_photos", :id => false, :force => true do |t|
    t.integer "album_id"
    t.integer "photo_id"
  end

  add_index "albums_photos", ["album_id", "photo_id"], :name => "index_albums_photos_on_album_id_and_photo_id"
  add_index "albums_photos", ["photo_id", "album_id"], :name => "index_albums_photos_on_photo_id_and_album_id"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "state",                                            :default => "started"
    t.string   "title"
    t.string   "topic"
    t.string   "host_firstname"
    t.string   "host_lastname"
    t.string   "host_business"
    t.text     "bio"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "website"
    t.string   "webshop"
    t.string   "permission"
    t.string   "payment_options"
    t.string   "paypal_email"
    t.string   "sendcheck_address"
    t.string   "sendcheck_address2"
    t.string   "sendcheck_city"
    t.string   "sendcheck_state"
    t.string   "sendcheck_zip"
    t.text     "description"
    t.date     "begins_at"
    t.date     "ends_at"
    t.integer  "hours"
    t.string   "hours_per",                                        :default => "week"
    t.string   "availability"
    t.string   "location_address"
    t.string   "location_address2"
    t.string   "location_city"
    t.string   "location_state"
    t.string   "location_zipcode"
    t.string   "location_private"
    t.string   "location_varies"
    t.integer  "age_min"
    t.integer  "age_max"
    t.integer  "registration_min"
    t.integer  "registration_max"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.string   "charge_id"
    t.string   "kind"
    t.string   "other_needs"
    t.decimal  "price",              :precision => 8, :scale => 2
    t.time     "begins_at_time"
    t.time     "ends_at_time"
    t.string   "location_nbrhood"
    t.string   "datetime_tba"
  end

  create_table "galleries", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "caption"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "gallery_id"
  end

  create_table "signups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "type"
    t.text     "happywhen"
    t.text     "collaborate"
    t.text     "interest"
    t.text     "experience"
    t.text     "requirements"
    t.string   "confirm_available"
    t.string   "preferred_times"
    t.string   "confirm_unpaid"
    t.string   "confirm_fee"
    t.string   "parent_phone"
    t.string   "parent_name"
    t.string   "parent_email"
    t.string   "waiver"
    t.string   "parents_waiver"
    t.string   "respect_agreement"
    t.string   "charge_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
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
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "birthday"
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "use_gravatar",           :default => true
    t.integer  "host_id"
    t.string   "phone"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
