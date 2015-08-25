ProductionOrderItem.for_produce.all.each do |item|
  kanban=item.kanban
  puts item.to_json
  # puts kanbanz.red
  unless (kanban && kanban.process_entities.first)
    item.update(state:ProductionOrderItemState::SYSTEM_ABORTED,message:'被删除，无法生产，系统停止')
  end
end