class CreatePartBoms < ActiveRecord::Migration
  def change
    create_table :part_boms do |t|
      t.references :part, index: true
      t.integer :bom_item_id
      t.integer :quantity

      t.timestamps
    end
    add_index :part_boms, :bom_item_id
  end
end
