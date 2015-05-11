class CreateProductionOrderItemLabels < ActiveRecord::Migration
  def change
    create_table :production_order_item_labels do |t|
      t.references :production_order_item, index: true
      t.integer :bundle_no
      t.float :qty
      t.string :nr
      t.integer :state

      t.timestamps
    end
  end
end
