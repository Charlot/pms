class CreateProductionOrders < ActiveRecord::Migration
  def change
    create_table :production_orders do |t|
      t.string :nr, null: false
      t.integer :orderable_id
      t.string :orderable_type
      t.timestamps
    end
    add_index :production_orders,:nr
    add_index :production_orders,:orderable_id
  end
end
