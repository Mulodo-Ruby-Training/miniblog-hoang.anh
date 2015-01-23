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

ActiveRecord::Schema.define(version: 20150121022715) do

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "content",    limit: 250
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.string   "title",       limit: 100
    t.string   "description", limit: 300
    t.text     "content"
    t.string   "image",       limit: 100
    t.boolean  "status",                  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",      limit: 64
    t.string   "salt_password", limit: 100
    t.string   "password",      limit: 100
    t.string   "token",         limit: 100
    t.string   "firstname",     limit: 30
    t.string   "lastname",      limit: 30
    t.string   "avatar",        limit: 100
    t.string   "address",       limit: 200
    t.string   "city",          limit: 30
    t.string   "email",         limit: 50
    t.string   "mobile",        limit: 20
    t.boolean  "gender",                    default: true
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
