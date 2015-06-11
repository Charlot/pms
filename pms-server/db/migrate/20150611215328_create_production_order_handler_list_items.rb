class CreateProductionOrderHandlerListItems < ActiveRecord::Migration
  def change
    create_table :production_order_handler_list_items do |t|
      t.string :nr
      t.string :desc
      t.string :kanban_code
      t.string :kanban_nr
      t.integer :result
      t.string :handler_user
      t.datetime :item_terminated_at
      t.references :production_order_handler_list#, index: true

      t.timestamps
    end
  end
end
