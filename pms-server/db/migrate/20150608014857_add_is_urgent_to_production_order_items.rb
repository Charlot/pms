class AddIsUrgentToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :is_urgent, :boolean, default: false
  end
end
