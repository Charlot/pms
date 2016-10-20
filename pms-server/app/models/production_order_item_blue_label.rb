class ProductionOrderItemBlueLabel < ProductionOrderItemLabel
  self.inheritance_column = :_type_disabled

  belongs_to :production_order_item_blue, foreign_key: :production_order_item_id#, class_name: 'ProductionOrderItem'
  default_scope { where(type: ProductionOrderItemType::BLUE) }


  after_commit :enter_stock
  # after_create :move_stock


  def enter_stock
    ItemBlueInStockWorker.perform_async(self.id)
  end

  # def move_stock
  #   if Setting.auto_move_kanban?
  #     ItemBlueMoveStockWorker.perform_async(self.id)
  #   end
  # end

end
