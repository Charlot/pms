class CreateProductionOrderHandlerItems < ActiveRecord::Migration
  def change
    create_table :production_order_handler_items do |t|
      t.string :nr
      t.string :desc
      t.text :remark
      t.string :kanban_code
      t.string :kanban_nr
      t.integer :result
      t.string :handler_user
      t.datetime :item_terminated_at
      t.integer :production_order_handler_id

      t.timestamps
    end
    add_index :production_order_handler_items,:production_order_handler_id,name:'production_order_handler_items_poh_index'
  end
end
