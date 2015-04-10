class AddPrevIndexToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :prev_index, :float, default: 0
  end
end
