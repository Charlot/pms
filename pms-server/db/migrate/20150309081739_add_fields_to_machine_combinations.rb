class AddFieldsToMachineCombinations < ActiveRecord::Migration
  def change
    add_column :machine_combinations, :complexity, :integer, default: 0
    add_column :machine_combinations, :match_start_index, :integer, default: 0
    add_column :machine_combinations, :match_end_index, :integer, default: 0
  end
end
