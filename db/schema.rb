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

ActiveRecord::Schema.define(:version => 20110707215609) do

  create_table "accounts", :force => true do |t|
    t.string    "facebook_token"
    t.string    "twitter_token"
    t.string    "twitter_secret"
    t.integer   "twitter_monthly_count"
    t.integer   "facebook_monthly_count"
    t.string    "mailchimp_api_key"
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "google_token"
    t.string    "google_secret"
    t.string    "google_profile_id"
  end

  create_table "accounts_users", :force => true do |t|
    t.string "account_id"
    t.string "user_id"
  end

  create_table "users", :force => true do |t|
    t.string    "email",                                 :default => "", :null => false
    t.string    "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.string    "confirmation_token"
    t.timestamp "confirmed_at"
    t.timestamp "confirmation_sent_at"
    t.string    "name"
    t.string    "phone"
    t.string    "type"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
