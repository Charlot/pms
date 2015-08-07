class AddAutoToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :auto, :boolean, default: true
  end
end
