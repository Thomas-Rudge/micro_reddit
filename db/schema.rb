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

ActiveRecord::Schema.define(version: 20170315192112) do

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "upvotes",    default: 0
    t.integer  "downvotes",  default: 0
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "link"
    t.text     "post_text"
    t.integer  "post_type"
    t.integer  "user_id"
    t.integer  "subreddit_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "upvotes",       default: 0
    t.integer  "downvotes",     default: 0
    t.string   "thumbnail"
    t.integer  "comment_count", default: 0
    t.index ["subreddit_id"], name: "index_posts_on_subreddit_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "subreddits", force: :cascade do |t|
    t.string   "name",                            null: false
    t.text     "description"
    t.boolean  "nsfw"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "mod"
    t.text     "sidebar"
    t.integer  "subscriptions_count", default: 0
    t.index ["name"], name: "index_subreddits_on_name", unique: true
    t.index ["subscriptions_count"], name: "index_subreddits_on_subscriptions_count"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subreddit_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["subreddit_id"], name: "index_subscriptions_on_subreddit_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "remember_digest"
    t.integer  "comment_karma",   default: 0
    t.integer  "post_karma",      default: 0
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "post_id",    null: false
    t.integer "comment_id"
    t.integer "vote",       null: false
    t.index ["post_id"], name: "index_votes_on_post_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

end
