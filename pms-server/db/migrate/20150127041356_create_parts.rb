class CreateParts < ActiveRecord::Migration
  def up
    create_table :parts do |t|
      t.string :nr
      t.string :custom_nr
      t.integer :type
      t.float :strip_length
      t.references :resource_group, index: true
      t.references :measure_unit, index: true

      t.timestamps
    end
    add_index :parts, :nr
    add_index :parts, :custom_nr
    add_index :parts, :type
  end

  def down
    drop_table :parts
  end
end
