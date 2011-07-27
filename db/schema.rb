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

ActiveRecord::Schema.define(:version => 20110727212753) do

  create_table "account_lists", :force => true do |t|
    t.integer  "account_id"
    t.string   "profile_name"
    t.string   "profile_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_id"
  end

  create_table "accounts", :force => true do |t|
    t.string   "facebook_token"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.integer  "twitter_monthly_count"
    t.integer  "facebook_monthly_count"
    t.string   "mailchimp_api_key"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google_token"
    t.string   "google_secret"
    t.string   "google_profile_id"
    t.string   "facebook_profile_id"
    t.string   "mailchimp_list_id"
    t.string   "twitter_name"
  end

  create_table "accounts_users", :force => true do |t|
    t.integer "account_id"
    t.integer "user_id"
    t.string  "access",     :default => "viewer"
    t.string  "status",     :default => "pending"
    t.boolean "creator",    :default => false
  end

  create_table "updates", :force => true do |t|
    t.text     "twitter_user"
    t.text     "tweets"
    t.text     "facebook_posts"
    t.text     "facebook_info"
    t.string   "facebook_picture"
    t.text     "current_analytics"
    t.text     "last_month_analytics"
    t.text     "two_months_ago_analytics"
    t.text     "three_months_ago_analytics"
    t.text     "mailchimp_growth"
    t.text     "mailchimp_chatter"
    t.text     "mailchimp_campaigns"
    t.text     "mailchimp_open_rates"
    t.text     "mailchimp_click_rates"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "name"
    t.string   "phone"
    t.string   "type_of_user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
