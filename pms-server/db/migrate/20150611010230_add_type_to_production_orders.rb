class AddTypeToProductionOrders < ActiveRecord::Migration
  def change
    add_column :production_orders, :type, :integer,default:ProductionOrderType::WHITE
  end
end
