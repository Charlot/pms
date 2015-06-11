module ProductionOrderItemBluesHelper
  def has_distribute_item_blues
    ProductionOrderItemBlue.has_for_distribute?
  end


end
