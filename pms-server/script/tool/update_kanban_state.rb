i=0

ProductionOrderItem.all.each do |item|
  if kb= Kanban.find_by_id(item.kanban_id)
    if item.produced_qty==kb.quantity
      puts "#{i+=1} . #{item.nr}--#{kb.nr}"
      item.update(state: ProductionOrderItemState::TERMINATED)
    end
  end
end