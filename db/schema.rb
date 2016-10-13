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

ActiveRecord::Schema.define(version: 20161013025016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "red_player_id"
    t.integer  "black_player_id"
    t.integer  "winner_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "moves", force: :cascade do |t|
    t.integer  "x_loc"
    t.integer  "y_loc"
    t.integer  "player_id"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_types", force: :cascade do |t|
    t.string "type"
  end

  create_table "players", force: :cascade do |t|
    t.string   "email"
    t.string   "pin"
    t.integer  "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "players", column: "black_player_id"
  add_foreign_key "games", "players", column: "red_player_id"
  add_foreign_key "moves", "games"
  add_foreign_key "moves", "players"
  add_foreign_key "players", "player_types", column: "type"
end