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

ActiveRecord::Schema.define(:version => 20110301232947) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "feeds", :force => true do |t|
    t.string "feed_id"
    t.string "picture"
    t.string "link"
  end

# Could not dump table "updates" because of following StandardError
#   Unknown type 'booloean' for column 'finished'

  create_table "users", :force => true do |t|
    t.string    "username"
    t.string    "client"
    t.string    "password"
    t.string    "twitter_token"
    t.string    "twitter_secret"
    t.string    "facebook_token"
    t.boolean   "fb_authenticated",        :default => false
    t.boolean   "twitter_authenticated",   :default => false
    t.string    "email"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "twitter_monthly_count"
    t.integer   "facebook_monthly_count"
    t.boolean   "analytics_authenticated", :default => false
    t.string    "analytics"
  end

end
