#
puts "======================".yellow
puts "修复看板数据错误".yellow
puts "======================".yellow
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
    #puts "不需要修改".green
  end
end

#
puts "======================".yellow
puts "修复Routing数据".yellow
puts "======================".yellow
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

#
puts "======================".yellow
puts "修复ProcessParts".yellow
puts "======================".yellow

ProcessEntity.all.each{|pe|
  if pe.value_default_wire_nr
    pe.process_parts.each{|pa|
      if pa.part.nr == pe.value_default_wire_nr
        pa.destroy
        puts "删除了#{pa.part.nr}"
      end
    }
  end
}

#
puts "======================".yellow
puts "发布看板".yellow
puts "======================".yellow
Kanban.includes(:kanban_process_entities).all.each do |kanban|
  kanban.without_versioning do
    kanban.update(state: KanbanState::RELEASED)
    #puts "#{kanban.nr}发布成功！".green
  end

  kanban.kanban_process_entities.each do |kpe|
    if kpe.process_entity.product_id != kanban.product_id
      puts "删除#{kanban.nr}下，多余的步骤:#{kpe.process_entity.nr}:#{kpe.process_entity.product_nr}".red
      kpe.destroy
    end
  end
end

#修复步骤属性
puts "======================".yellow
puts "修复步骤属性".yellow
puts "======================".yellow
CustomField.all.each do |cf|
  if cf.name == "default_wire_nr"
    cf.update(is_for_out_stock:false)
    cf.custom_values.each do |cv|
      if (pp =cv.customized.process_parts.where(part_id:cv.value)).count > 0
        puts "删除#{pp.count}个零件"
        pp.each{|p|p.destroy}
      end
    end
  end
end