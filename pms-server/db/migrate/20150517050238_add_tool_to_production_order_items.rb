class AddToolToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :tool1, :string
    add_column :production_order_items, :tool2, :string
  end
end
