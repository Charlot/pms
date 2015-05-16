class AddTypeToProductionOrderItem < ActiveRecord::Migration
  def change
    add_column :production_order_items, :type, :integer,default:ProductionOrderItemType::WHITE
  end
end
