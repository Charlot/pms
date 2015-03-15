class CreateProductionOrderItems < ActiveRecord::Migration
  def change
    create_table :production_order_items do |t|
      t.string :nr
      t.integer :state, default: ProductionOrderItemState::INIT
      t.string :code
      t.text :message
      t.references :kanban, index: true
      t.references :production_order, index: true
      t.references :machine, index: true
      t.integer :optimise_index, default: 0
      t.timestamp :optimise_at

      t.timestamps
    end
    add_index :production_order_items, :nr
  end
end