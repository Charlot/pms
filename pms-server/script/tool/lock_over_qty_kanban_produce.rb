i=0
ProductionOrderItem.where(state: [ProductionOrderItemState::INIT,
                                  ProductionOrderItemState::OPTIMISE_SUCCEED,
                                  ProductionOrderItemState::DISTRIBUTE_SUCCEED]).all.each_with_index do |item,i|
  puts i
  puts item.to_json

  if kanban=Kanban.find_by_id(item.kanban_id)
    puts "#{kanban.nr}-#{kanban.quantity}".yellow
    if kanban.quantity>200
      puts "#{i+=1} : #{kanban.nr}--#{kanban.quantity}".red
      item.update(state: ProductionOrderItemState::SYSTEM_ABORTED)
    end
  end
end

