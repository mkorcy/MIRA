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

ActiveRecord::Schema.define(version: 20150626175634) do

  create_table "batches", force: true do |t|
    t.integer  "creator_id"
    t.string   "template_id"
    t.string   "type"
    t.text     "pids"
    t.datetime "created_at"
    t.text     "job_ids"
    t.string   "record_type"
    t.text     "metadata_file", limit: 2147483647
    t.string   "behavior"
  end

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id",     null: false
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  create_table "deposit_types", force: true do |t|
    t.string   "display_name"
    t.text     "deposit_agreement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "deposit_view"
    t.string   "license_name"
  end

  create_table "roles", force: true do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id"

  create_table "searches", force: true do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id"

  create_table "sequences", force: true do |t|
    t.integer "value", default: 0
    t.string  "scope"
  end

  create_table "uploaded_files", force: true do |t|
    t.integer "batch_id"
    t.string  "pid"
    t.string  "dsid"
    t.string  "filename"
  end

  add_index "uploaded_files", ["batch_id"], name: "index_uploaded_files_on_batch_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",                  default: false
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
