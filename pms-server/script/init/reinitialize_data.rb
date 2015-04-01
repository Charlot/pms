# 修复看板数据错误
Kanban.where(ktype:KanbanType::WHITE).each do |k|
  if k.process_entities.count > 1
    if k.process_entities.where(product_id:k.product_id).count <=0
      puts "需要重新建立关联 #{k.nr}".yellow
      pe_nr = k.process_entities.first.nr
      process_entity = ProcessEntity.where(nr:pe_nr,product_id:k.product_id).first
      if process_entity
        Kanban.transaction do
          new_pe = KanbanProcessEntity.new(kanban_id:k.id,process_entity_id:process_entity.id)
          k.process_entities << new_pe
          k.save
          k.kanban_process_entities.where("process_entity_id not ?",process_entity.id).each{|pe|pe.destroy}
        end
      else
        puts "未找到Routing，步骤号#{pe_nr}，总成号#{k.product_nr}".red
      end
    else
      k.kanban_process_entities.joins(:process_entity).where("process_entities.product_id != ?",k.product_id).each{|e|e.destroy}
    end
  else
    puts "不需要修改".green
  end
end

# 修复Routing数据
ProcessEntity.joins(:process_template).where("process_templates.type = ?",ProcessType::AUTO).each do |pe|
  pe.custom_values.each{|cv|
    if cv.custom_field.name == "default_wire_nr"
      wire_nr =  "#{pe.product_nr}_#{cv.value}"

      if Part.where(nr:wire_nr,type:PartType::PRODUCT_SEMIFINISHED).count <= 0
        Part.transaction do
          begin
            puts "新建线号:#{wire_nr}".green
            Part.create({nr:wire_nr,type:PartType::PRODUCT_SEMIFINISHED})
          rescue => e
            puts e.backtrace
          end
        end
      end
    end
  }
end