class AddColumnToMachineTimeRules < ActiveRecord::Migration
  def change
    add_column :machine_time_rules, :std_time, :double
  end
end
