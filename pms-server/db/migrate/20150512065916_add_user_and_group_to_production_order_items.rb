class AddUserAndGroupToProductionOrderItems < ActiveRecord::Migration
  def change
    add_column :production_order_items, :user_nr, :string
    add_column :production_order_items, :user_group_nr, :string
  end
end
