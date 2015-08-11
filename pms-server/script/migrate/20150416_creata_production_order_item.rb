=begin
product = Part.where({nr:"93NMA001A",type:PartType::PRODUCT}).first
nrs = [
    'ZE20','ZE21','ZZ91','ZJ08',
    ''
    ]
pes = ProcessEntity.where(product_id:product.id).select{|pe| nrs.include? pe.parsed_wire_nr}
i = 1
pes.each{|pe|
  kanban = pe.kanbans.first
  if kanban

    @kanban = kanban

    if @kanban.quantity <= 0
      next
    end
    # if ProductionOrderItem.where(kanban_id: @kanban.id, state: ProductionOrderItemState::INIT).count > 0
    #   next
    # end
    #
    #if ProductionOrderItem.where(kanban_id: @kanban.id).count > 0
    #  next
    #end


    process_entity = @kanban.process_entities.first
    if process_entity && process_entity.process_parts.count > 0
      can_create = true
      parts = []
      process_entity.process_parts.each { |pe|
        part = pe.part
        # if (part.type == PartType::MATERIAL_TERMINAL) && (part.tool == nil)
        #   can_create = false
        # end
        if can_create #&& part.type == PartType::MATERIAL_TERMINAL
          parts << part.nr
        end
      }

      # if process_entity.process_parts.select { |pe| pe.part.type == PartType::MATERIAL_TERMINAL }.count <= 0
      #   can_create = false
      # end

      if can_create
        unless (@order = ProductionOrderItem.create(kanban_id: @kanban.id, code: @kanban.printed_2DCode))
          next
        end

        puts "新建订单成功：#{@kanban.nr},#{parts.join('-')}".green
      end
    else
      puts "步骤不存在！或步骤不消耗零件!".red
    end
  end
}=end
