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

ActiveRecord::Schema.define(:version => 20111027061506) do

  create_table "google_accounts", :force => true do |t|
    t.string   "display_name"
    t.string   "email"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", :force => true do |t|
    t.string   "calender_name"
    t.string   "calender_url"
    t.string   "youroom_access_token"
    t.string   "youroom_access_token_secret"
    t.string   "room_name"
    t.integer  "room_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "youroom_users", :force => true do |t|
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end
