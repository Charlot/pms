class ChangeStateOfProductionOrderItemLabels < ActiveRecord::Migration
  def up
    change_column_default :production_order_item_labels, :state, ProductionOrderItemLabel::INIT
  end

  def down

  end
end
