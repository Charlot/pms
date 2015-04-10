class CreateMasterBomItems < ActiveRecord::Migration
  def change
    create_table :master_bom_items do |t|
      t.float :qty
      t.integer :bom_item_id
      t.integer :product_id
      t.references :department, index: true

      t.timestamps
    end
    add_index :master_bom_items, :bom_item_id
    add_index :master_bom_items, :product_id
  end
end
