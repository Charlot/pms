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

ActiveRecord::Schema.define(version: 20150208121528) do

  create_table "custom_fields", force: true do |t|
    t.string   "custom_fieldable_type"
    t.integer  "custom_fieldable_id"
    t.string   "type"
    t.string   "name",                                  null: false
    t.string   "field_format",                          null: false
    t.text     "possible_values"
    t.string   "regexp"
    t.integer  "min_length"
    t.integer  "max_length"
    t.boolean  "is_required",           default: false, null: false
    t.boolean  "is_for_all",            default: false, null: false
    t.boolean  "is_filter",             default: false, null: false
    t.boolean  "is_for_out_stock",      default: false, null: false
    t.integer  "position",              default: 1
    t.boolean  "searchable",            default: false, null: false
    t.text     "default_value"
    t.boolean  "editable",              default: true
    t.boolean  "visible",               default: true,  null: false
    t.boolean  "multiple",              default: false
    t.text     "format_store"
    t.boolean  "is_query_value",        default: false
    t.boolean  "is_auto_query_value",   default: false
    t.text     "validate_query"
    t.string   "validate_message"
    t.text     "value_query"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_fields", ["custom_fieldable_id", "custom_fieldable_type"], name: "custom_fieldable_index", using: :btree
  add_index "custom_fields", ["id", "type"], name: "index_custom_fields_on_id_and_type", using: :btree
  add_index "custom_fields", ["type"], name: "index_custom_fields_on_type", using: :btree

  create_table "custom_values", force: true do |t|
    t.string   "customized_type"
    t.integer  "customized_id"
    t.boolean  "is_for_out_stock", default: false, null: false
    t.integer  "custom_field_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_values", ["custom_field_id"], name: "index_custom_values_on_custom_field_id", using: :btree
  add_index "custom_values", ["customized_type", "customized_id"], name: "index_custom_values_on_customized_type_and_customized_id", using: :btree

  create_table "kanban_process_entities", force: true do |t|
    t.integer  "kanban_id"
    t.integer  "process_entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kanban_process_entities", ["kanban_id"], name: "index_kanban_process_entities_on_kanban_id", using: :btree
  add_index "kanban_process_entities", ["process_entity_id"], name: "index_kanban_process_entities_on_process_entity_id", using: :btree

  create_table "kanbans", force: true do |t|
    t.string   "nr",                             null: false
    t.string   "remark"
    t.float    "quantity",         default: 0.0
    t.float    "safety_stock",     default: 0.0, null: false
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
    t.integer  "ktype"
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

  create_table "process_entities", force: true do |t|
    t.string   "nr",                                null: false
    t.string   "name"
    t.text     "description"
    t.float    "stand_time",          default: 0.0
    t.integer  "process_template_id"
    t.integer  "workstation_type_id"
    t.integer  "cost_center_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "process_entities", ["cost_center_id"], name: "index_process_entities_on_cost_center_id", using: :btree
  add_index "process_entities", ["process_template_id"], name: "index_process_entities_on_process_template_id", using: :btree
  add_index "process_entities", ["workstation_type_id"], name: "index_process_entities_on_workstation_type_id", using: :btree

  create_table "process_templates", force: true do |t|
    t.string   "code"
    t.integer  "type"
    t.string   "name"
    t.text     "template"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "process_templates", ["code"], name: "index_process_templates_on_code", using: :btree
  add_index "process_templates", ["type"], name: "index_process_templates_on_type", using: :btree

  create_table "production_orders", force: true do |t|
    t.string   "nr",             null: false
    t.integer  "orderable_id"
    t.string   "orderable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "production_orders", ["nr"], name: "index_production_orders_on_nr", using: :btree
  add_index "production_orders", ["orderable_id"], name: "index_production_orders_on_orderable_id", using: :btree

end
