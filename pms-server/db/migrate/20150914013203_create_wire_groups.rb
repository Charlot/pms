class CreateWireGroups < ActiveRecord::Migration
  def change
    create_table :wire_groups do |t|
      t.string :group_name, default: ''
      t.string :wire_type, default: ''
      t.decimal :cross_section, :precision => 6, :scale => 4, default: 0

      t.timestamps
    end
    add_index :wire_groups, :group_name
    add_index :wire_groups, :wire_type
  end
end
