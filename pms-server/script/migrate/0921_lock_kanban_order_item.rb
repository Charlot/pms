Kanban.unscoped.where(state: KanbanState::DESTROYED).each_with_index do |k, i|
  # puts "-#{i}..#{k.nr}"
  k.production_order_items.where(state: [ProductionOrderItemState::OPTIMISE_FAIL,
                                         ProductionOrderItemState::OPTIMISE_SUCCEED,
                                         ProductionOrderItemState::OPTIMISE_CANCELED,
                                         ProductionOrderItemState::DISTRIBUTE_FAIL,
                                         ProductionOrderItemState::DISTRIBUTE_SUCCEED]).each_with_index do |item, j|
    puts "---#{j}..#{k.nr}--#{item.nr}".yellow

    item.update_attributes(state:ProductionOrderItemState::SYSTEM_ABORTED,message:'kanban is destroyed after item created')
  end
end