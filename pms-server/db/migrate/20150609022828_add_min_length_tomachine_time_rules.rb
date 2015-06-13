class AddMinLengthTomachineTimeRules < ActiveRecord::Migration
  def change
    add_column :machine_time_rules, :min_length, :float
  end
end
