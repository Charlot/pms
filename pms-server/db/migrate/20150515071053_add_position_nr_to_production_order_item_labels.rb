class AddPositionNrToProductionOrderItemLabels < ActiveRecord::Migration
  def change
    add_column :production_order_item_labels, :whouse_nr, :string
    add_column :production_order_item_labels, :position_nr, :string
  end
end
