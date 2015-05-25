ProductionOrderItem.all.each {|poi|
  if poi.kanban.quantity <= 0
    poi.update(state:ProductionOrderItemState::OPTIMISE_CANCELED)
    puts "取消订单#{poi.id},#{poi.kanban.nr}"
  end
}