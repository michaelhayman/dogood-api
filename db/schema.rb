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

ActiveRecord::Schema.define(version: 20130807222001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "good_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["good_id"], name: "index_comments_on_good_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "goods", force: true do |t|
    t.string   "caption"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods", ["category_id"], name: "index_goods_on_category_id", using: :btree
  add_index "goods", ["user_id"], name: "index_goods_on_user_id", using: :btree

  create_table "likes", force: true do |t|
    t.integer  "user_id"
    t.string   "likeable"
    t.integer  "likeable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "regoods", force: true do |t|
    t.integer  "user_id"
    t.integer  "good_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regoods", ["good_id"], name: "index_regoods_on_good_id", using: :btree
  add_index "regoods", ["user_id"], name: "index_regoods_on_user_id", using: :btree

  create_table "rewards", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_rewards", force: true do |t|
    t.integer  "user_id"
    t.integer  "reward_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_rewards", ["reward_id"], name: "index_user_rewards_on_reward_id", using: :btree
  add_index "user_rewards", ["user_id"], name: "index_user_rewards_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
