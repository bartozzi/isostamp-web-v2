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

ActiveRecord::Schema.define(version: 20160425225831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: :cascade do |t|
    t.string   "attachment"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "kind",       null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "tagfinder_executions", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.integer  "data_file_id",   null: false
    t.integer  "params_file_id"
    t.boolean  "email_sent"
    t.boolean  "success"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tagfinder_executions", ["data_file_id"], name: "index_tagfinder_executions_on_data_file_id", using: :btree
  add_index "tagfinder_executions", ["params_file_id"], name: "index_tagfinder_executions_on_params_file_id", using: :btree
  add_index "tagfinder_executions", ["user_id"], name: "index_tagfinder_executions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "admin",      default: false
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "tagfinder_executions", "users"
end
