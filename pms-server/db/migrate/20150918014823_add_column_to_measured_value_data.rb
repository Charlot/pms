class AddColumnToMeasuredValueData < ActiveRecord::Migration
  change_table :measured_value_records do |t|
    t.string :machine_id, default: ''
    t.index :machine_id
  end
end
