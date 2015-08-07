class AddQtyToProductionOrderHandlerItems < ActiveRecord::Migration
  def change
    add_column :production_order_handler_items, :qty, :float
  end
end
