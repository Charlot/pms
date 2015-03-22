module ProductionOrderItemsHelper
  def has_optimise_items
    ProductionOrderItem.for_optimise.count>0
  end

  def has_distribute_items(production_order)
    ProductionOrderItem.for_distribute(production_order).count>0
  end
end
