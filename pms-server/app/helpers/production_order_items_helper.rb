module ProductionOrderItemsHelper
  def has_optimise_items
    ProductionOrderItem.for_optimise.count>0
  end
end
