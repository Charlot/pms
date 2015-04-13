product=Part.find_by_nr('93NMA001A')
order=ProductionOrder.find_by_nr('000004')
i=0
if order
  order.production_order_items.where(state: ProductionOrderItemState::DISTRIBUTE_SUCCEED).all.each do |item|
    kb=Kanban.find_by_id(item.kanban_id)
    if kb.product_id!=product.id
      puts "(#{i+=1}) terminate order item:#{item.nr}---kb:#{kb.nr}"
      item.update(state: ProductionOrderItemState::SYSTEM_ABORTED)
    end
  end
end