class AddTerminateFieldsToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :terminated_at, :datetime
    add_column :production_order_items, :terminate_user, :string
    add_column :production_order_items, :terminated_kanban_code, :string
  end
end
