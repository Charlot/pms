class ChangeMachineTimeRuleTimeToDouble < ActiveRecord::Migration
  def up
    change_column :machine_time_rules, :time, :float,:limit => 25, default: 0
  end

  def down
    change_column :machine_time_rules, :time, :float, default: 0
  end
end
