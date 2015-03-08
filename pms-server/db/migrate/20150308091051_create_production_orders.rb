class CreateProductionOrders < ActiveRecord::Migration
  def change
    create_table :production_orders do |t|
      t.references :kanban, index: true
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
