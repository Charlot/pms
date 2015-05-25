modified_1 = [
    {product_nr:"93S351313",route_nr:"2210-140",part_nr:"P00153728"},
    {product_nr:"93S351313",route_nr:"2210-170",part_nr:"P00153728"}
]
#修复KANBAN数据

#修改CustomValues
modified_1.each do |m|
  product = Part.find_by_nr(m[:product_nr])
  if product && (pe1= ProcessEntity.where({nr:m[:route_nr],product_id:product.id}).first)
    pe1.custom_values.each{|cv|
      cf = cv.custom_field
      if CustomFieldFormatType.part?(cf.field_format) && (part = Part.find_by_id(cv.value)) && (new_part = Part.find_by_nr(m[:part_nr]))
        if part.type == PartType::MATERIAL_TERMINAL && part.nr != new_part.nr
          ProcessEntity.transaction do
            cv.value = new_part.id
            pp = nil
            if old_pp = pe1.process_parts.where({part_id:part.id}).first
              pp = ProcessPart.new({part_id:new_part.id,process_entity_id:pe1.id,quantity:old_pp.quantity})
              old_pp.destroy
            else
              pp = ProcessPart.new({part_id:new_part.id,process_entity_id:pe1.id,quantity:1})
            end
            pe1.process_parts<<pp
            pe1.save
            cv.save
            puts "更新了#{pe1.nr},#{pe1.id},#{product.nr}的端子,#{new_part.nr}".green
          end
        end
      end
    }
  end
end

modified_2 = {product_nr:"93S351313",route_nr:"2210-3460",part_nr:"Ring-51-1",new_part_nr:"Ring-52-1"}
product = Part.find_by_nr(modified_2[:product_nr])
if product && (pe = ProcessEntity.where({nr:modified_2[:route_nr]}).first) && (part = Part.find_by_nr("#{modified_2[:product_nr]}_#{modified_2[:part_nr]}")) && (new_part = Part.find_by_nr("#{modified_2[:product_nr]}_#{modified_2[:new_part_nr]}"))
  puts "--------".red
  pe.custom_values.each do |cv|
    if cv.value == part.id
      ProcessEntity.transaction do
        #cv.value = new_part.id
        puts "#{part.nr}"
      end
    end
  end
end

#修改ProcessParts