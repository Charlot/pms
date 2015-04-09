puts "----------------------------------------------".red
puts "该操作将清空所有的生产订单，不能在生产环境下使用".red
puts "----------------------------------------------".red

ProductionOrder.destroy_all
ProductionOrderItem.destroy_all

Kanban.where({ktype: KanbanType::WHITE}).each_with_index {|k,index|
  @kanban = k

  if ProductionOrderItem.where(kanban_id: @kanban.id, state: ProductionOrderItemState::INIT).count > 0
    next
  end

  process_entity = @kanban.process_entities.first
  if process_entity
    can_create = true
    parts = []
    process_entity.process_parts.each{|pe|
      part = pe.part
      if (part.type == PartType::MATERIAL_TERMINAL) && (part.tool == nil)
        can_create = false
      end
      if can_create #&& part.type == PartType::MATERIAL_TERMINAL
        parts << part.nr
      end
    }

    #if process_entity.process_parts.select{|pe| pe.part.type == PartType::MATERIAL_TERMINAL}.count <= 0
    #  can_create = false
    #end

    if can_create
      unless (@order = ProductionOrderItem.create(kanban_id: @kanban.id,code:@kanban.printed_2DCode))
        next
      end

      puts "新建订单成功：#{@kanban.nr},#{parts.join('-')}".green
    end
  else
    puts "步骤不存在！"
  end
}