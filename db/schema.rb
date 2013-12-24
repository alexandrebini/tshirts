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

ActiveRecord::Schema.define(version: 6) do

  create_table "assets", force: true do |t|
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.string   "type"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.string   "data_file_size"
    t.text     "data_meta"
    t.string   "data_fingerprint"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["assetable_id", "assetable_type"], name: "index_assets_on_assetable_id_and_assetable_type", using: :btree
  add_index "assets", ["assetable_id"], name: "index_assets_on_assetable_id", using: :btree
  add_index "assets", ["assetable_type"], name: "index_assets_on_assetable_type", using: :btree
  add_index "assets", ["type"], name: "index_assets_on_type", using: :btree

  create_table "colors", force: true do |t|
    t.integer "t_shirt_id"
    t.string  "hex"
    t.integer "percentage"
  end

  add_index "colors", ["hex", "percentage"], name: "index_colors_on_hex_and_percentage", using: :btree
  add_index "colors", ["hex"], name: "index_colors_on_hex", using: :btree
  add_index "colors", ["percentage"], name: "index_colors_on_percentage", using: :btree
  add_index "colors", ["t_shirt_id"], name: "index_colors_on_t_shirt_id", using: :btree

  create_table "prices", force: true do |t|
    t.integer  "t_shirt_id"
    t.integer  "value"
    t.datetime "created_at"
  end

  add_index "prices", ["created_at"], name: "index_prices_on_created_at", using: :btree
  add_index "prices", ["t_shirt_id", "value", "created_at"], name: "index_prices_on_t_shirt_id_and_value_and_created_at", using: :btree
  add_index "prices", ["t_shirt_id", "value"], name: "index_prices_on_t_shirt_id_and_value", using: :btree
  add_index "prices", ["t_shirt_id"], name: "index_prices_on_t_shirt_id", using: :btree
  add_index "prices", ["value"], name: "index_prices_on_value", using: :btree

  create_table "sizes", force: true do |t|
    t.integer "t_shirt_id"
    t.integer "label"
    t.string  "gender"
  end

  add_index "sizes", ["gender"], name: "index_sizes_on_gender", using: :btree
  add_index "sizes", ["label"], name: "index_sizes_on_label", using: :btree
  add_index "sizes", ["t_shirt_id", "gender"], name: "index_sizes_on_t_shirt_id_and_gender", using: :btree
  add_index "sizes", ["t_shirt_id", "label", "gender"], name: "index_sizes_on_t_shirt_id_and_label_and_gender", using: :btree
  add_index "sizes", ["t_shirt_id", "label"], name: "index_sizes_on_t_shirt_id_and_label", using: :btree
  add_index "sizes", ["t_shirt_id"], name: "index_sizes_on_t_shirt_id", using: :btree

  create_table "sources", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "start_url"
    t.text     "verification_matcher"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["name"], name: "index_sources_on_name", unique: true, using: :btree

  create_table "t_shirts", force: true do |t|
    t.integer  "source_id"
    t.string   "slug"
    t.string   "gender"
    t.string   "title"
    t.string   "description"
    t.string   "source_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "t_shirts", ["created_at"], name: "index_t_shirts_on_created_at", using: :btree
  add_index "t_shirts", ["slug"], name: "index_t_shirts_on_slug", using: :btree
  add_index "t_shirts", ["source_id"], name: "index_t_shirts_on_source_id", using: :btree

end
