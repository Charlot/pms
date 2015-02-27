class CreateResourceGroups < ActiveRecord::Migration
  def change
    create_table :resource_groups do |t|
      t.string :nr
      t.integer :type
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :resource_groups, :nr
    add_index :resource_groups, :type
  end
end
