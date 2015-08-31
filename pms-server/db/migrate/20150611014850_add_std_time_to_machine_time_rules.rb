class AddStdTimeToMachineTimeRules < ActiveRecord::Migration
  def change
    add_index :machine_time_rules, :min_length
    add_index :machine_time_rules, :length
  end
end
