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

ActiveRecord::Schema.define(version: 20150513173924) do

  create_table "points", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "picture"
    t.integer  "counterpoint_to_id"
  end

  add_index "points", ["counterpoint_to_id"], name: "index_points_on_counterpoint_to_id"
  add_index "points", ["user_id", "counterpoint_to_id"], name: "index_points_on_user_id_and_counterpoint_to_id", unique: true
  add_index "points", ["user_id", "created_at"], name: "index_points_on_user_id_and_created_at"
  add_index "points", ["user_id"], name: "index_points_on_user_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "votes", force: :cascade do |t|
    t.string   "vote_type"
    t.integer  "point_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "votes", ["point_id", "vote_type"], name: "index_votes_on_point_id_and_vote_type"
  add_index "votes", ["point_id"], name: "index_votes_on_point_id"
  add_index "votes", ["user_id", "point_id"], name: "index_votes_on_user_id_and_point_id", unique: true
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
