class CreateCrimpConfigurations < ActiveRecord::Migration
  def change
    create_table :crimp_configurations do |t|
      t.string :custom_id
      t.string :wire_group_name
      t.string :part_id
      t.string :wire_type
      t.float :cross_section, default: 0

      t.timestamps
    end
    add_index :crimp_configurations, :wire_group_name
    add_index :crimp_configurations, :part_id
    add_index :crimp_configurations, :wire_type
  end
end
