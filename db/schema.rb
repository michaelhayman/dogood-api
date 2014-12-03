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

ActiveRecord::Schema.define(version: 20141203183007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges_sashes", force: true do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id", using: :btree
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id", using: :btree
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name_constant"
    t.string   "colour"
    t.string   "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "claimed_rewards", force: true do |t|
    t.integer  "user_id"
    t.integer  "reward_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "claimed_rewards", ["reward_id"], name: "index_claimed_rewards_on_reward_id", using: :btree
  add_index "claimed_rewards", ["user_id"], name: "index_claimed_rewards_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "devices", force: true do |t|
    t.string   "token"
    t.string   "provider"
    t.boolean  "is_valid",   default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["token"], name: "index_devices_on_token", unique: true, using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "entities", force: true do |t|
    t.integer "link_id",         null: false
    t.text    "link_type",       null: false
    t.text    "title",           null: false
    t.integer "entityable_id",   null: false
    t.string  "entityable_type", null: false
    t.string  "range",           null: false, array: true
  end

  add_index "entities", ["entityable_id", "entityable_type"], name: "index_entities_on_entityable_id_and_entityable_type", using: :btree
  add_index "entities", ["link_id"], name: "index_entities_on_link_id", using: :btree
  add_index "entities", ["title"], name: "index_entities_on_title", using: :btree

  create_table "follows", force: true do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "goods", force: true do |t|
    t.text     "caption",                               null: false
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_comments_count",  default: 0
    t.integer  "cached_votes_total",     default: 0
    t.integer  "cached_votes_score",     default: 0
    t.integer  "cached_votes_up",        default: 0
    t.integer  "cached_votes_down",      default: 0
    t.string   "evidence"
    t.integer  "cached_followers_count", default: 0
    t.float    "lat"
    t.float    "lng"
    t.string   "location_image"
    t.string   "location_name"
    t.boolean  "done",                   default: true
    t.integer  "nominee_id"
    t.integer  "cached_following_count", default: 0
    t.integer  "cached_weighted_score",  default: 0
    t.string   "slug"
  end

  add_index "goods", ["cached_votes_down"], name: "index_goods_on_cached_votes_down", using: :btree
  add_index "goods", ["cached_votes_score"], name: "index_goods_on_cached_votes_score", using: :btree
  add_index "goods", ["cached_votes_total"], name: "index_goods_on_cached_votes_total", using: :btree
  add_index "goods", ["cached_votes_up"], name: "index_goods_on_cached_votes_up", using: :btree
  add_index "goods", ["cached_weighted_score"], name: "index_goods_on_cached_weighted_score", using: :btree
  add_index "goods", ["category_id"], name: "index_goods_on_category_id", using: :btree
  add_index "goods", ["nominee_id"], name: "index_goods_on_nominee_id", using: :btree
  add_index "goods", ["slug"], name: "index_goods_on_slug", using: :btree
  add_index "goods", ["user_id"], name: "index_goods_on_user_id", using: :btree

  create_table "merit_actions", force: true do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    default: false
    t.string   "target_model"
    t.integer  "target_id"
    t.boolean  "processed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: true do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: true do |t|
    t.integer  "score_id"
    t.integer  "num_points", default: 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", force: true do |t|
    t.integer "sash_id"
    t.string  "category", default: "default"
  end

  create_table "nominees", force: true do |t|
    t.string  "full_name",                   null: false
    t.string  "email"
    t.string  "phone"
    t.string  "twitter_id"
    t.string  "facebook_id"
    t.string  "avatar"
    t.integer "user_id",     default: 0
    t.boolean "invite",      default: false
  end

  add_index "nominees", ["user_id"], name: "index_nominees_on_user_id", using: :btree

  create_table "points", force: true do |t|
    t.string   "pointable_type",     null: false
    t.integer  "pointable_id",       null: false
    t.string   "pointable_sub_type", null: false
    t.integer  "to_user_id",         null: false
    t.integer  "from_user_id"
    t.integer  "points",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points", ["from_user_id"], name: "index_points_on_from_user_id", using: :btree
  add_index "points", ["pointable_id", "pointable_type"], name: "index_points_on_pointable_id_and_pointable_type", using: :btree
  add_index "points", ["to_user_id"], name: "index_points_on_to_user_id", using: :btree

  create_table "reports", force: true do |t|
    t.string   "reportable_type"
    t.integer  "reportable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["reportable_id", "reportable_type"], name: "index_reports_on_reportable_id_and_reportable_type", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "rewards", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "cost",               default: 0
    t.integer  "quantity",           default: 0
    t.integer  "quantity_remaining", default: 0
    t.text     "full_description"
    t.string   "teaser"
    t.text     "instructions"
  end

  add_index "rewards", ["user_id"], name: "index_rewards_on_user_id", using: :btree

  create_table "sashes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_hashtag_hashtaggings", force: true do |t|
    t.integer "hashtag_id"
    t.integer "hashtaggable_id"
    t.string  "hashtaggable_type"
  end

  add_index "simple_hashtag_hashtaggings", ["hashtag_id"], name: "index_simple_hashtag_hashtaggings_on_hashtag_id", using: :btree
  add_index "simple_hashtag_hashtaggings", ["hashtaggable_id", "hashtaggable_type"], name: "index_hashtaggings_hashtaggable_id_hashtaggable_type", using: :btree

  create_table "simple_hashtag_hashtags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unsubscribes", force: true do |t|
    t.text "email", null: false
  end

  add_index "unsubscribes", ["email"], name: "index_unsubscribes_on_email", using: :btree

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
    t.string   "avatar"
    t.integer  "cached_followers_count", default: 0
    t.string   "full_name"
    t.string   "phone"
    t.integer  "points_cache",           default: 0
    t.string   "location"
    t.string   "biography"
    t.string   "facebook_id"
    t.string   "twitter_id"
    t.integer  "sash_id"
    t.integer  "level",                  default: 0
    t.integer  "cached_following_count", default: 0
    t.string   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_id"], name: "index_users_on_facebook_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree
  add_index "users", ["twitter_id"], name: "index_users_on_twitter_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_weight"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
