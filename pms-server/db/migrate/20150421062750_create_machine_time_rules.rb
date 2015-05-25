class CreateMachineTimeRules < ActiveRecord::Migration
  def change
    create_table :machine_time_rules do |t|
      t.references :oee_code, index: true
      t.references :machine_type, index: true
      t.float :length
      t.float :time

      t.timestamps
    end
  end
end
