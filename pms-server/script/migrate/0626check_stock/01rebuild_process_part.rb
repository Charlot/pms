ProcessEntity.transaction do
# rebuild auto process entity process part
  ProcessEntity.joins(:process_template).where(process_templates: {type: ProcessType::AUTO}).each_with_index do |pe, i|
    puts "#{i} build #{pe.id}-#{pe.nr} process parts".red
    pe.process_parts.destroy_all
    pe.custom_values.each do |cv|
      cf=cv.custom_field
      if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
        qty=pe.process_part_quantity_by_cf(cf.name.to_sym)
        if cv.value.present? && (Part.find(cv.value).type==PartType::MATERIAL_WIRE) && qty.to_f>10
          qty=qty.to_f/1000
        end if Setting.auto_convert_material_length?
        pe.process_parts<<ProcessPart.new(part_id: cv.value, quantity: qty, custom_value_id: cv.id)
      end
    end
  end

# # # rebuild semi auto process entity custom_value && process parts
  ProcessEntity.joins(:process_template).where(process_templates: {type: ProcessType::SEMI_AUTO}).each_with_index do |pe, i|
    puts "#{i} build #{pe.nr} process parts".yellow
    pe.custom_values.where.not(id: pe.custom_values.group(:custom_field_id).pluck(:id)).destroy_all
    arrs=pe.process_parts.pluck(:id)
    pe.custom_values.select { |cv| (cv.custom_field.name != "default_wire_nr")&&(cv.custom_field.field_format=="part") }.each_with_index do |cv, index|
      puts "#{cv.value}"
      cf=cv.custom_field
      if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
        if cv.value
          pe.process_parts<<ProcessPart.new(part_id: cv.value,
                                            quantity: (pp=pe.process_parts.where(part_id: cv.value).first).nil? ? 1 : pp.quantity,
                                            custom_value_id: cv.id)
        end
      end
    end

    pe.process_parts.where(id: arrs).destroy_all
  end
end