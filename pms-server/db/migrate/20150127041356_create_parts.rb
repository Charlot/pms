class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :nr
      t.string :custom_nr
      t.integer :part_type
      t.float :strip_length
      t.references :measure_unit, index: true

      t.timestamps
    end
    add_index :parts, :nr
    add_index :parts, :custom_nr
    add_index :parts, :part_type
  end
end
