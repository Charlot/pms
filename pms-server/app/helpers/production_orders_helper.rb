module ProductionOrdersHelper
  def production_order_options
    ProductionOrder.all.collect { |p| [p.nr, p.id] }
  end
end
