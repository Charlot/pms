class AddMachineTimeToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :machine_time, :float, default: 0
  end
end
