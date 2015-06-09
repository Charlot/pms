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

ActiveRecord::Schema.define(version: 20150609022828) do

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

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "code"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["parent_id"], name: "index_departments_on_parent_id", using: :btree

  create_table "kanban_process_entities", force: true do |t|
    t.integer  "kanban_id"
    t.integer  "process_entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",          default: 0
    t.integer  "state",             default: 100
  end

  add_index "kanban_process_entities", ["kanban_id"], name: "index_kanban_process_entities_on_kanban_id", using: :btree
  add_index "kanban_process_entities", ["process_entity_id"], name: "index_kanban_process_entities_on_process_entity_id", using: :btree

  create_table "kanbans", force: true do |t|
    t.string   "nr",                             null: false
    t.string   "remark"
    t.integer  "quantity",         default: 0
    t.float    "safety_stock",     default: 0.0, null: false
    t.integer  "copies",           default: 0
    t.integer  "state",            default: 0
    t.string   "source_warehouse"
    t.string   "source_storage"
    t.string   "des_warehouse"
    t.string   "des_storage"
    t.datetime "print_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ktype"
    t.integer  "product_id",                     null: false
    t.integer  "bundle",           default: 0
    t.string   "remark2",          default: ""
  end

  add_index "kanbans", ["nr"], name: "index_kanbans_on_nr", using: :btree
  add_index "kanbans", ["product_id"], name: "index_kanbans_on_product_id", using: :btree

  create_table "machine_combinations", force: true do |t|
    t.integer  "w1"
    t.integer  "t1"
    t.integer  "t2"
    t.integer  "s1"
    t.integer  "s2"
    t.string   "wd1"
    t.integer  "w2"
    t.integer  "t3"
    t.integer  "t4"
    t.integer  "s3"
    t.integer  "s4"
    t.string   "wd2"
    t.integer  "machine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "complexity",        default: 0
    t.integer  "match_start_index", default: 0
    t.integer  "match_end_index",   default: 0
  end

  add_index "machine_combinations", ["machine_id"], name: "index_machine_combinations_on_machine_id", using: :btree

  create_table "machine_scopes", force: true do |t|
    t.boolean  "w1",         default: false
    t.boolean  "t1",         default: false
    t.boolean  "t2",         default: false
    t.boolean  "s1",         default: false
    t.boolean  "s2",         default: false
    t.boolean  "wd1",        default: false
    t.boolean  "w2",         default: false
    t.boolean  "t3",         default: false
    t.boolean  "t4",         default: false
    t.boolean  "s3",         default: false
    t.boolean  "s4",         default: false
    t.boolean  "wd2",        default: false
    t.integer  "machine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "machine_scopes", ["machine_id"], name: "index_machine_scopes_on_machine_id", using: :btree

  create_table "machine_time_rules", force: true do |t|
    t.integer  "oee_code_id"
    t.integer  "machine_type_id"
    t.float    "length"
    t.float    "time",            default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "min_length"
  end

  add_index "machine_time_rules", ["machine_type_id"], name: "index_machine_time_rules_on_machine_type_id", using: :btree
  add_index "machine_time_rules", ["oee_code_id"], name: "index_machine_time_rules_on_oee_code_id", using: :btree

  create_table "machine_types", force: true do |t|
    t.string   "nr"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "machines", force: true do |t|
    t.string   "nr"
    t.string   "name"
    t.string   "description"
    t.integer  "resource_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "print_time",        default: 45.0
    t.float    "seal_time",         default: 40.0
    t.float    "terminal_time",     default: 15.0
    t.float    "wire_time",         default: 5.0
    t.integer  "status",            default: 0
    t.string   "ip"
    t.integer  "machine_type_id"
    t.float    "wire_length_time",  default: 2.0
  end

  add_index "machines", ["machine_type_id"], name: "index_machines_on_machine_type_id", using: :btree
  add_index "machines", ["nr"], name: "index_machines_on_nr", using: :btree
  add_index "machines", ["resource_group_id"], name: "index_machines_on_resource_group_id", using: :btree

  create_table "master_bom_items", force: true do |t|
    t.float    "qty"
    t.integer  "bom_item_id"
    t.integer  "product_id"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "master_bom_items", ["bom_item_id"], name: "index_master_bom_items_on_bom_item_id", using: :btree
  add_index "master_bom_items", ["department_id"], name: "index_master_bom_items_on_department_id", using: :btree
  add_index "master_bom_items", ["product_id"], name: "index_master_bom_items_on_product_id", using: :btree

  create_table "measure_units", force: true do |t|
    t.string   "code"
    t.string   "describe"
    t.string   "cn"
    t.string   "en"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_units", ["code"], name: "index_measure_units_on_code", using: :btree

  create_table "ncr_api_logs", force: true do |t|
    t.string   "machine_nr"
    t.string   "order_item_nr"
    t.integer  "log_type"
    t.integer  "order_item_state"
    t.float    "order_item_qty"
    t.text     "params_detail"
    t.text     "return_detail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oee_codes", force: true do |t|
    t.string   "nr"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "part_boms", force: true do |t|
    t.integer  "part_id"
    t.integer  "bom_item_id"
    t.float    "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_boms", ["bom_item_id"], name: "index_part_boms_on_bom_item_id", using: :btree
  add_index "part_boms", ["part_id"], name: "index_part_boms_on_part_id", using: :btree

  create_table "part_positions", force: true do |t|
    t.integer  "part_id"
    t.string   "storage"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "part_process_entities", force: true do |t|
    t.integer  "part_id"
    t.integer  "process_entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_process_entities", ["part_id"], name: "index_part_process_entities_on_part_id", using: :btree
  add_index "part_process_entities", ["process_entity_id"], name: "index_part_process_entities_on_process_entity_id", using: :btree

  create_table "parts", force: true do |t|
    t.string   "nr"
    t.string   "custom_nr"
    t.integer  "type"
    t.float    "strip_length"
    t.integer  "resource_group_id"
    t.integer  "measure_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "color"
    t.string   "color_desc"
    t.string   "component_type"
    t.float    "cross_section",     default: 0.0
  end

  add_index "parts", ["custom_nr"], name: "index_parts_on_custom_nr", using: :btree
  add_index "parts", ["measure_unit_id"], name: "index_parts_on_measure_unit_id", using: :btree
  add_index "parts", ["nr"], name: "index_parts_on_nr", using: :btree
  add_index "parts", ["resource_group_id"], name: "index_parts_on_resource_group_id", using: :btree
  add_index "parts", ["type"], name: "index_parts_on_type", using: :btree

  create_table "positions", force: true do |t|
    t.string   "detail"
    t.integer  "warehouse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["warehouse_id"], name: "index_positions_on_warehouse_id", using: :btree

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
    t.integer  "product_id",                        null: false
    t.text     "remark"
  end

  add_index "process_entities", ["cost_center_id"], name: "index_process_entities_on_cost_center_id", using: :btree
  add_index "process_entities", ["process_template_id"], name: "index_process_entities_on_process_template_id", using: :btree
  add_index "process_entities", ["product_id"], name: "index_process_entities_on_product_id", using: :btree
  add_index "process_entities", ["workstation_type_id"], name: "index_process_entities_on_workstation_type_id", using: :btree

  create_table "process_parts", force: true do |t|
    t.float    "quantity",          default: 0.0
    t.integer  "part_id"
    t.integer  "process_entity_id"
    t.integer  "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "process_parts", ["part_id"], name: "index_process_parts_on_part_id", using: :btree
  add_index "process_parts", ["process_entity_id"], name: "index_process_parts_on_process_entity_id", using: :btree

  create_table "process_templates", force: true do |t|
    t.string   "code"
    t.integer  "type"
    t.string   "name"
    t.text     "template"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wire_from",   default: 0
  end

  add_index "process_templates", ["code"], name: "index_process_templates_on_code", using: :btree
  add_index "process_templates", ["type"], name: "index_process_templates_on_type", using: :btree

  create_table "production_order_item_labels", force: true do |t|
    t.integer  "production_order_item_id"
    t.integer  "bundle_no"
    t.float    "qty"
    t.string   "nr"
    t.integer  "state",                    default: 90
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "whouse_nr"
    t.string   "position_nr"
  end

  add_index "production_order_item_labels", ["production_order_item_id"], name: "index_production_order_item_labels_on_production_order_item_id", using: :btree

  create_table "production_order_items", force: true do |t|
    t.string   "nr"
    t.integer  "state",               default: 100
    t.string   "code"
    t.text     "message"
    t.integer  "kanban_id"
    t.integer  "production_order_id"
    t.integer  "machine_id"
    t.float    "optimise_index",      default: 0.0
    t.datetime "optimise_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produced_qty"
    t.float    "machine_time",        default: 0.0
    t.float    "prev_index",          default: 0.0
    t.string   "user_nr"
    t.string   "user_group_nr"
    t.integer  "type",                default: 100
    t.string   "tool1"
    t.string   "tool2"
    t.float    "kanban_qty",          default: 0.0
    t.float    "kanban_bundle",       default: 0.0
    t.boolean  "is_urgent",           default: false
  end

  add_index "production_order_items", ["kanban_id"], name: "index_production_order_items_on_kanban_id", using: :btree
  add_index "production_order_items", ["machine_id"], name: "index_production_order_items_on_machine_id", using: :btree
  add_index "production_order_items", ["nr"], name: "index_production_order_items_on_nr", using: :btree
  add_index "production_order_items", ["production_order_id"], name: "index_production_order_items_on_production_order_id", using: :btree

  create_table "production_orders", force: true do |t|
    t.string   "nr"
    t.integer  "state",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "production_orders", ["nr"], name: "index_production_orders_on_nr", using: :btree

  create_table "resource_group_parts", force: true do |t|
    t.integer  "part_id"
    t.integer  "resource_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_group_parts", ["part_id"], name: "index_resource_group_parts_on_part_id", using: :btree
  add_index "resource_group_parts", ["resource_group_id"], name: "index_resource_group_parts_on_resource_group_id", using: :btree

  create_table "resource_groups", force: true do |t|
    t.string   "nr"
    t.integer  "type"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_groups", ["nr"], name: "index_resource_groups_on_nr", using: :btree
  add_index "resource_groups", ["type"], name: "index_resource_groups_on_type", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "settings", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "stype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "storages", force: true do |t|
    t.string   "nr"
    t.integer  "warehouse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "part_id"
    t.integer  "position_id"
    t.integer  "quantity"
  end

  add_index "storages", ["warehouse_id"], name: "index_storages_on_warehouse_id", using: :btree

  create_table "tools", force: true do |t|
    t.string   "nr"
    t.integer  "resource_group_id"
    t.integer  "part_id"
    t.integer  "mnt",               default: 0
    t.integer  "used_days"
    t.integer  "rql"
    t.integer  "tol",               default: 0
    t.datetime "rql_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nr_display"
  end

  add_index "tools", ["nr"], name: "index_tools_on_nr", using: :btree
  add_index "tools", ["part_id"], name: "index_tools_on_part_id", using: :btree
  add_index "tools", ["resource_group_id"], name: "index_tools_on_resource_group_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "user_name",              default: ""
    t.string   "name",                   default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nr"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "warehouses", force: true do |t|
    t.string   "nr"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
