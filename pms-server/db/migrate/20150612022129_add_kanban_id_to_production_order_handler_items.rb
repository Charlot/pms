class AddKanbanIdToProductionOrderHandlerItems < ActiveRecord::Migration
  def change
    add_column :production_order_handler_items, :kanban_id, :integer
  end
end
