#
puts "======================".yellow
puts "1.修复看板数据错误".yellow
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
puts "2.修复Routing数据".yellow
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
puts "3.修复ProcessParts".yellow
puts "======================".yellow

ProcessEntity.all.each{|pe|
  if pe.value_default_wire_nr
    pe.process_parts.each{|pa|
      if pa.part && pa.part.nr == pe.value_default_wire_nr
        pa.destroy
        puts "删除了#{pa.part.nr}"
      end
    }
  end
}

#
puts "======================".yellow
puts "4.发布看板".yellow
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
puts "5.修复步骤属性".yellow
puts "======================".yellow
CustomField.all.each do |cf|
  if cf.name == "default_wire_nr"
    cf.update(is_for_out_stock:false)
    cf.custom_values.each do |cv|
      if (pp =cv.customized.process_parts.where(part_id:cv.value)).count > 0
        puts "#{pp.collect{|p|p.part.nr}.join(',')},删除#{pp.count}个零件损耗".red
        pp.each{|p|p.destroy}
      end
    end
  end
end

#修复步骤属性
puts "======================".yellow
puts "6.修复看板库位".yellow
puts "======================".yellow
Kanban.all.each {|k|
  if (k.des_storage.nil? || k.des_storage.blank?) && k.source_storage
    k.without_versioning do
      k.update(des_storage:k.source_storage)
    end
    puts "更新库位:#{k.nr},目标库位#{k.des_storage}".green
  end
}

#修复陈旧看板数据
puts "======================".yellow
puts "7.修复陈旧看板数据".yellow
puts "======================".yellow
KanbanProcessEntity.all.each do |kpe|
  process_entity = kpe.process_entity
  if process_entity.kanbans.count > 1
    k = process_entity.kanbans.first
    process_entity.kanbans.each{|kanban|
      if k.process_entities.count < kanban.process_entities.count
        k = kanban
      end
      puts "#{kanban.nr}:#{kanban.process_entities.collect{|pe|pe.nr}.join(',')}"
    }
    (process_entity.kanbans - [k]).each{|x|
      x.destroy
      puts "删除#{x.nr}"
    }
    puts "============================"
  end
end

oee_codes = %w(CC CW CS WW SW SS)
oee_des = [
    "两端压端子",
    "一端压端子，一端剥线",
    "一端压端子，一端防水圈",
    "两端剥线",
    "一端剥线，一端防水圈",
    "两端防水圈"
]

#
puts "======================".yellow
puts "8.新建Oee Code 工时代码".yellow
puts "======================".yellow
OeeCode.destroy_all
oee_codes.each_with_index do |oee,i|
  if (o= OeeCode.find_by_nr(oee)).present?
    o.update({description:oee_des[i]})
  else
    o = OeeCode.create({nr:oee,description:oee_des[i]})
  end
  o.save
end

MachineType.destroy_all
["CC36","CC64"].each do |type|
  MachineType.create({nr:type})
end

puts "======================".yellow
puts "9.看板库位信息".yellow
puts "======================".yellow
["PA01","SR01","SRPL","3PL"].each do |wh|
  if warehouse = Warehouse.find_by_nr(wh)

  else
    warehouse = Warehouse.create({nr:wh})
    puts "新建仓库#{wh}".green
  end
end

# 新建库位信息
# 通过看板和Cutting零件位置来创建库位

cutting = Warehouse.find_by_nr("SR01")
cutting_material = Warehouse.find_by_nr("SRPL")
assembly = Warehouse.find_by_nr("3PL")

cutting_array = ["FC","MC","TC"]
assembly_array = ["XF","XM","XT"]

Kanban.all.each do |k|
  if k.des_storage.nil?
    next
  end
  store = k.des_storage.split(" ").first
  if cutting_array.include?(store)
    pos = Position.find_by_detail(k.des_storage)
    if pos.nil?
      pos = Position.create({detail:k.des_storage,warehouse_id:cutting.id})
      puts "新建库位#{pos.detail},#{cutting.nr}".green
    end
  end

  if assembly_array.include?(store)
    pos = Position.find_by_detail(k.des_storage)
    if pos.nil?
      pos = Position.create({detail:k.des_storage,warehouse_id:assembly.id})
      puts "新建库位#{pos.detail},#{assembly.nr}".green
    end
  end
end

PartPosition.all.each do |pp|
  store = pp.storage
  pos = Position.find_by_detail(store)
  if pos.nil?
    pos = Position.create({detail:store,warehouse_id:cutting_material.id})
    puts "新建库位#{pos.detail},#{cutting_material.nr}".green
  end
end