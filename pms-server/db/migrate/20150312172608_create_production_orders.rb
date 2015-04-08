class CreateProductionOrders < ActiveRecord::Migration
  def change
    create_table :production_orders do |t|
      t.string :nr
      t.integer :state, default: ProductionOrderState::INIT

      t.timestamps
    end
    add_index :production_orders, :nr
  end
end
