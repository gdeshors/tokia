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

ActiveRecord::Schema.define(version: 20150220093002) do

  create_table "ais", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.integer  "elo"
    t.string   "version"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "command_line"
    t.string   "filename"
    t.string   "language"
    t.string   "firstparam"
  end

  create_table "events", force: true do |t|
    t.string   "version"
    t.integer  "ai_id"
    t.string   "commentaire"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "log_a"
    t.string   "log_b"
    t.string   "log_c"
    t.string   "log_d"
    t.string   "log_server"
    t.string   "gamelog"
    t.integer  "winner_id"
    t.integer  "match_id"
    t.integer  "ai_1_id"
    t.integer  "ai_2_id"
    t.string   "commentaire"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "log_cartes"
    t.string   "ending"
  end

  add_index "games", ["created_at"], name: "index_games_on_created_at"
  add_index "games", ["match_id"], name: "index_games_on_match_id"
  add_index "games", ["winner_id"], name: "index_games_on_winner_id"

  create_table "matches", force: true do |t|
    t.integer  "ai_1_id"
    t.integer  "ai_2_id"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "new_elo_1"
    t.integer  "new_elo_2"
  end

  add_index "matches", ["ai_1_id"], name: "index_matches_on_ai_1_id"
  add_index "matches", ["ai_2_id"], name: "index_matches_on_ai_2_id"
  add_index "matches", ["created_at"], name: "index_matches_on_created_at"
  add_index "matches", ["winner_id"], name: "index_matches_on_winner_id"

  create_table "pending_games", force: true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.boolean  "validated",       default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
