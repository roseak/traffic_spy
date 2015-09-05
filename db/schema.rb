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

ActiveRecord::Schema.define(version: 20150905170835) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.text "identifier"
    t.text "root_url"
  end

  create_table "events", force: :cascade do |t|
    t.text "name"
  end

  create_table "operating_systems", force: :cascade do |t|
    t.text "operating_system"
  end

  create_table "referral", force: :cascade do |t|
    t.text "url"
  end

  create_table "referrals", force: :cascade do |t|
    t.text "referred_by"
  end

  create_table "request_types", force: :cascade do |t|
    t.text "request_type"
  end

  create_table "resolutions", force: :cascade do |t|
    t.text "resolution"
  end

  create_table "shas", force: :cascade do |t|
    t.text "sha"
  end

  create_table "urls", force: :cascade do |t|
    t.text    "url"
    t.integer "client_id"
  end

  create_table "user_envs", force: :cascade do |t|
    t.text "user_agent"
    t.text "resolution_width"
    t.text "resolution_height"
    t.text "ip"
  end

  create_table "visits", force: :cascade do |t|
    t.text    "requested_at"
    t.text    "responded_in"
    t.integer "url_id"
    t.integer "referral_id"
    t.integer "event_id"
    t.integer "user_env_id"
    t.integer "request_type_id"
    t.integer "resolution_id"
    t.integer "web_browser_id"
    t.integer "operating_system_id"
  end

  create_table "web_browsers", force: :cascade do |t|
    t.text "browser"
  end

end
