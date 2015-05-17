class ProductionOrderItemLabel < ActiveRecord::Base
  belongs_to :production_order_item

  after_create :update_production_order_item_state
  after_create :enter_store

  def update_production_order_item_state
    unless self.production_order_item.state==ProductionOrderItemState::TERMINATED
      qty=self.production_order_item.production_order_item_labels.sum(:qty)
      if (kb =self.production_order_item.kanban) && (qty>=kb.quantity)
        self.production_order_item.update(state: ProductionOrderItemState::TERMINATED)
      end
    end
  end

  def enter_store
    
  end
end
