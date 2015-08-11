class CreateProductionOrderHandlers < ActiveRecord::Migration
  def change
    create_table :production_order_handlers do |t|
      t.string :nr
      t.string :desc
      t.string :remark

      t.timestamps
    end
  end
end
