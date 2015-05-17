class ChangeStateOfProductionOrderItemLabels < ActiveRecord::Migration
  def change
    change_column :production_order_item_labels,:state,:integer,default: ProductionOrderItemLabel::INIT
  end
end
