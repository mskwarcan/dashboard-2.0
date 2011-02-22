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

ActiveRecord::Schema.define(:version => 20110222194754) do

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "client"
    t.string   "password"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "facebook_token"
    t.boolean  "fb_authenticated",       :default => false
    t.boolean  "twitter_authenticated",  :default => false
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_monthly_count"
    t.integer  "facebook_monthly_count"
  end

end
