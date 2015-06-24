class AddTypeToProductionOrderItemLabels < ActiveRecord::Migration
  def change
    add_column :production_order_item_labels, :type, :integer,default:ProductionOrderItemType::WHITE
  end
end
