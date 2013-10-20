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

ActiveRecord::Schema.define(version: 20131020182519) do

  create_table "ais", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.integer  "elo"
    t.string   "version"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "ai_1_id"
    t.integer  "ai_2_id"
    t.integer  "winner"
    t.integer  "winner1"
    t.integer  "winner2"
    t.string   "log1"
    t.string   "log2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["ai_1_id"], name: "index_matches_on_ai_1_id"
  add_index "matches", ["ai_2_id"], name: "index_matches_on_ai_2_id"
  add_index "matches", ["winner"], name: "index_matches_on_winner"
  add_index "matches", ["winner1"], name: "index_matches_on_winner1"
  add_index "matches", ["winner2"], name: "index_matches_on_winner2"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
