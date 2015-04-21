module ProductionOrdersHelper
  def production_order_options
    ProductionOrder.limit(30).order(id: :desc).collect { |p| [p.nr, p.id] }
  end
end
