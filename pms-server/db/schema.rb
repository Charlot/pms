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

ActiveRecord::Schema.define(version: 20150202024904) do

  create_table "kanbans", force: true do |t|
    t.string   "nr",                             null: false
    t.string   "remark"
    t.float    "quantity",         default: 0.0
    t.float    "safety_stock",                   null: false
    t.float    "task_time",        default: 0.0
    t.integer  "copies",           default: 0
    t.integer  "state",            default: 0
    t.integer  "version",          default: 1
    t.string   "source_warehouse"
    t.string   "source_storage"
    t.string   "des_warehouse"
    t.string   "des_storage"
    t.integer  "part_id"
    t.datetime "print_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kanbans", ["nr"], name: "index_kanbans_on_nr", using: :btree
  add_index "kanbans", ["part_id"], name: "index_kanbans_on_part_id", using: :btree

  create_table "measure_units", force: true do |t|
    t.string   "code"
    t.string   "describe"
    t.string   "cn"
    t.string   "en"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_units", ["code"], name: "index_measure_units_on_code", using: :btree

  create_table "part_boms", force: true do |t|
    t.integer  "part_id"
    t.integer  "bom_item_id"
    t.float    "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_boms", ["bom_item_id"], name: "index_part_boms_on_bom_item_id", using: :btree
  add_index "part_boms", ["part_id"], name: "index_part_boms_on_part_id", using: :btree

  create_table "parts", force: true do |t|
    t.string   "nr"
    t.string   "custom_nr"
    t.integer  "part_type"
    t.integer  "measure_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["custom_nr"], name: "index_parts_on_custom_nr", using: :btree
  add_index "parts", ["measure_unit_id"], name: "index_parts_on_measure_unit_id", using: :btree
  add_index "parts", ["nr"], name: "index_parts_on_nr", using: :btree
  add_index "parts", ["part_type"], name: "index_parts_on_part_type", using: :btree

end
