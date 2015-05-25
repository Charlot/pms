module ProductionOrdersHelper
  def production_order_options
    ProductionOrder.offset(offset).limit(50).collect { |p| [p.nr, p.id] }
  end

  # best in place options
  def production_order_bip_options(production_order)
    ProductionOrder.where.not(id: production_order.id).offset(offset).limit(50).collect { |p| [p.id, p.nr] }<<[production_order.id, production_order.nr]
  end

  private
  def offset
    ProductionOrder.count<50 ? 0 : (ProductionOrder.count-50)
  end
end
