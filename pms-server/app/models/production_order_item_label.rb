class ProductionOrderItemLabel < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  belongs_to :production_order_item
  default_scope { where(type: ProductionOrderItemType::WHITE) }

  INIT=90
  IN_STORE=100
  ENTER_STOCK_FAIL=200


  after_create :update_production_order_item_state
  after_create :enter_stock
  after_create :move_stock
  after_create :update_tool_cut_count

  def update_production_order_item_state
    unless self.production_order_item.state==ProductionOrderItemState::TERMINATED
      qty=self.production_order_item.production_order_item_labels.sum(:qty)
      if self.production_order_item.kanban_qty.present?
        if qty>=self.production_order_item.kanban_qty
          self.production_order_item.update(state: ProductionOrderItemState::TERMINATED)
        end
      else
        if (kb =self.production_order_item.kanban) && (qty>=kb.quantity)
          self.production_order_item.update(state: ProductionOrderItemState::TERMINATED)
        end
      end
    end if self.type==ProductionOrderItemType::WHITE
  end

  def enter_stock
    ItemLabelInStockWorker.perform_async(self.id) if self.type==ProductionOrderItemType::WHITE
  end

  def move_stock
    if Setting.auto_move_kanban?
      ItemLabelMoveStockWorker.perform_async(self.id)
    end if self.type==ProductionOrderItemType::WHITE
  end

  def update_tool_cut_count
    UpdateToolCutCountWorker.perform_async(self.id) if self.type==ProductionOrderItemType::WHITE
  end
end
