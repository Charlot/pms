class ProductionOrderItemBlue<ProductionOrderItem
  default_scope { where(type: ProductionOrderItemType::BLUE) }
  belongs_to :production_order_blue, foreign_key: :production_order_id#, class_name: 'ProductionOrder'
  has_many :production_order_item_blue_labels, foreign_key: :production_order_item_id

  before_update :set_produced_qty
  # after_update :enter_stock
  # after_update :move_stock

  after_update :generate_blue_label

  def generate_blue_label
    if self.state_changed? and self.state==ProductionOrderItemState::TERMINATED
      bundle=1
      position_nr=Warehouse::DEFAULT_POSITION
      whouse_nr=Warehouse::DEFAULT_WAREHOUSE
      if self.kanban
        position_nr= self.kanban.des_storage
        whouse_nr=Warehouse.get_whouse_by_position_prefix(self.kanban.des_storage)
      end

      puts whouse_nr.red

      self.production_order_item_blue_labels.create(nr: "#{self.nr}-#{bundle.to_i.to_s}",
                                                    qty: produced_qty,
                                                    bundle_no: bundle,
                                                    position_nr: position_nr,
                                                    whouse_nr: whouse_nr)
    end
  end

  def move_stock
    if self.state_changed? and self.state==ProductionOrderItemState::TERMINATED
      if Setting.auto_move_kanban?
        ItemBlueMoveStockWorker.perform_async(self.id)
      end
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