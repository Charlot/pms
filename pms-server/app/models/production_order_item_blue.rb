class ProductionOrderItemBlue<ProductionOrderItem
  default_scope { where(type: ProductionOrderItemType::BLUE) }
  belongs_to :production_order_blue, foreign_key: :production_order_id

  before_update :set_produced_qty
  after_update :enter_stock
  after_update :move_stock

  def enter_stock
# TODO blue card terminated to enter stock
  end

  def move_stock
    if self.state_changed? and self.state==ProductionOrderItemState::TERMINATED
     # ItemBlueMoveStockWorker.perform_async(self.id)
    end
  end

  def self.in_produces
    where(state: ProductionOrderItemState::INIT)
  end

  def self.for_distribute
    where(state: ProductionOrderItemState::INIT)
  end

  def self.has_for_distribute?
    where(state: ProductionOrderItemState::INIT).count>0
  end

  def set_produced_qty
    if self.state_changed? && self.state==ProductionOrderItemState::TERMINATED
      self.produced_qty=self.kanban_qty
    end
  end
end