class AddColumnsToCrimpConfigurations < ActiveRecord::Migration
  def change
    add_column :crimp_configurations, :min_pulloff_value, :float, default: 0
    add_column :crimp_configurations, :crimp_height, :float, default: 0
    add_column :crimp_configurations, :crimp_height_iso, :float, default: 0
    add_column :crimp_configurations, :crimp_width, :float, default: 0
    add_column :crimp_configurations, :crimp_width_iso, :float, default: 0
    add_column :crimp_configurations, :i_crimp_height, :float, default: 0
    add_column :crimp_configurations, :i_crimp_height_iso, :float, default: 0
    add_column :crimp_configurations, :i_crimp_width, :float, default: 0
    add_column :crimp_configurations, :i_crimp_width_iso, :float, default: 0
  end
end
