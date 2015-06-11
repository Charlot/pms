class CreateProductionOrderHandlerLists < ActiveRecord::Migration
  def change
    create_table :production_order_handler_lists do |t|
      t.string :nr
      t.string :desc

      t.timestamps
    end
  end
end
