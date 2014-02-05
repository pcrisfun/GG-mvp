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

ActiveRecord::Schema.define(:version => 20140121233432) do

  create_table "admins", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "album_photo_maps", :force => true do |t|
    t.integer  "album_id"
    t.integer  "photo_id"
    t.integer  "position"
    t.boolean  "featured"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "gallery_id"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "limit"
  end

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
    t.boolean  "permission",                                       :default => false
    t.boolean  "boolean",                                          :default => false
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
    t.string   "location_address"
    t.string   "location_address2"
    t.string   "location_city"
    t.string   "location_state"
    t.string   "location_zipcode"
    t.boolean  "location_private",                                 :default => true
    t.boolean  "location_varies",                                  :default => false
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
    t.boolean  "datetime_tba",                                     :default => false
    t.string   "respect_my_style"
    t.integer  "prereg_id"
    t.boolean  "gender",                                           :default => false
    t.boolean  "follow_up_sent",                                   :default => false,     :null => false
    t.boolean  "reminder_sent",                                    :default => false,     :null => false
    t.text     "availability"
    t.text     "reject_reason"
    t.text     "revoke_reason"
    t.string   "legal_name"
  end

  add_index "events", ["charge_id"], :name => "index_events_on_charge_id"

  create_table "galleries", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "caption"
    t.boolean  "protected",         :default => false
    t.integer  "gallery_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "preregs", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "preregs", ["event_id", "user_id"], :name => "index_preregs_on_event_id_and_user_id", :unique => true

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
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "parent"
    t.string   "daughter_firstname"
    t.string   "daughter_lastname"
    t.integer  "daughter_age"
    t.string   "state",                     :default => "started"
    t.boolean  "app_reminder_sent",         :default => false,     :null => false
    t.boolean  "app_followup_sent",         :default => false,     :null => false
    t.boolean  "app_followup_maker_sent",   :default => false,     :null => false
    t.boolean  "work_first_reminder_sent",  :default => false,     :null => false
    t.boolean  "work_second_reminder_sent", :default => false,     :null => false
    t.boolean  "work_followup_sent",        :default => false,     :null => false
    t.text     "decline_reason"
  end

  add_index "signups", ["charge_id"], :name => "index_signups_on_charge_id"

  create_table "state_stamps", :force => true do |t|
    t.string   "state"
    t.date     "stamp"
    t.integer  "event_id"
    t.integer  "signup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.text     "bio"
    t.string   "website"
    t.string   "webshop"
    t.string   "facebook"
    t.string   "twitter"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
