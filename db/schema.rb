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

ActiveRecord::Schema.define(version: 20160224195637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "comment_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_udx", unique: true, using: :btree
  add_index "comment_hierarchies", ["descendant_id"], name: "comment_desc_idx", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.text     "comment"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "convo_id"
    t.integer  "parent_id"
    t.integer  "points",         default: 0
    t.integer  "upvotes",        default: 0
    t.integer  "downvotes",      default: 0
    t.float    "weighted_score", default: 0.0
    t.integer  "user_id"
  end

  add_index "comments", ["convo_id"], name: "index_comments_on_convo_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "convos", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "url"
    t.text     "comment"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "topic_id"
    t.integer  "points",         default: 0
    t.integer  "scrape_id"
    t.integer  "upvotes",        default: 0
    t.integer  "downvotes",      default: 0
    t.float    "weighted_score", default: 0.0
    t.text     "convo"
    t.integer  "user_id"
  end

  add_index "convos", ["scrape_id"], name: "index_convos_on_scrape_id", using: :btree
  add_index "convos", ["topic_id"], name: "index_convos_on_topic_id", using: :btree
  add_index "convos", ["user_id"], name: "index_convos_on_user_id", using: :btree

  create_table "scrapes", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.text     "images"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "guest"
    t.string   "ip"
  end

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",          default: false, null: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true, using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

  add_foreign_key "comments", "convos"
  add_foreign_key "comments", "users"
  add_foreign_key "convos", "scrapes"
  add_foreign_key "convos", "topics"
  add_foreign_key "convos", "users"
end
