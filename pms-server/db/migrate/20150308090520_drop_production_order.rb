class DropProductionOrder < ActiveRecord::Migration
  def change
    drop_table :production_orders
  end
end
