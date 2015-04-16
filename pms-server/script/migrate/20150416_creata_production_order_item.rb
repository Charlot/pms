product = Part.where({nr:"93NMA001A",type:PartType::PRODUCT}).first
nrs = [
    'LB50','MB10','MA35','MA41',
    'MB50','MA20','MB40','PI24',
    'ZK00','EP01','ZEP1','DE21',
    'ZL04','ZE50','ZE20','ZE21',
    'ZH00','ZZ90','ZA05','LD30(1)',
    'QA50','PI51(1)','LB35','LB34',
    'AB10','DA07-','DA07(1)','ST01',
    'ZP86','ZL01','MC34','PF20',
    'AB10','LB35','HL04(1)','AA38',
    'LD20','HC45','HC45-','HA61-'
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
}