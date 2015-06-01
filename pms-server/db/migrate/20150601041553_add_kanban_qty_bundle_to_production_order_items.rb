class AddKanbanQtyBundleToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :kanban_qty, :float,default: 0
    add_column :production_order_items, :kanban_bundle, :float,default: 0
  end
end
