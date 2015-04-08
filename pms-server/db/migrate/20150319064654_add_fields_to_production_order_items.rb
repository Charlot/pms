class AddFieldsToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :produced_qty, :integer
  end
end
