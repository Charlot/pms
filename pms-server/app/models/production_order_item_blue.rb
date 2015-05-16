class ProductionOrderItemBlue<ProductionOrderItem
  default_scope { where(type: ProductionOrderItemType::BLUE) }


  after_update :enter_stock
  after_update :move_stock

  def enter_stock
# TODO blue card terminated to enter stock
  end

  def move_stock
    if self.state_changed? and self.state==ProductionOrderItemState::TERMINATED

    end
  end
end