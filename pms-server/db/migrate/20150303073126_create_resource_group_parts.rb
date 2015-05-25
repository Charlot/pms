class CreateResourceGroupParts < ActiveRecord::Migration
  def change
    create_table :resource_group_parts do |t|
      t.references :part, index: true
      t.references :resource_group, index: true

      t.timestamps
    end
  end
end
