PartBom.destroy_all
puts PartBom.count

ProcessEntity.joins(:process_template).where(process_templates: {type: ProcessType::AUTO})
    .all.each_with_index do |pe, i|
  puts "#{pe.code}----#{pe.type}" unless pe.value_default_wire_nr
  if part=Part.find_by_id(pe.value_default_wire_nr)
    puts "#{i}--#{pe.nr} generate #{part.nr} part bom"
    if wire=Part.find_by_id(pe.value_wire_nr)
      raise 'wire error' if pe.value_wire_qty_factor.blank?
      puts "wire: #{wire.nr}---#{pe.value_wire_qty_factor}".red
      PartBom.create(part_id: part.id, bom_item_id: wire.id, quantity: pe.value_wire_qty_factor)
    end
    if t1=Part.find_by_id(pe.value_t1)
      raise 't1 error' if pe.value_t1_qty_factor.blank?
      puts "t1: #{t1.nr}---#{pe.value_t1_qty_factor}".blue
      PartBom.create(part_id: part.id, bom_item_id: t1.id, quantity: pe.value_t1_qty_factor)
    end

    if t2=Part.find_by_id(pe.value_t2)
      raise 't2 error' if pe.value_t2_qty_factor.blank?
      puts "t2: #{t2.nr}---#{pe.value_t2_qty_factor}".blue
      if pb=PartBom.where(part_id: part.id, bom_item_id: t2.id).first
        puts "-----------t1 & t2".yellow
        pb.update(quantity: (pb.quantity+pe.value_t2_qty_factor.to_f))
      else
        PartBom.create(part_id: part.id, bom_item_id: t2.id, quantity: pe.value_t2_qty_factor)
      end
    end

    if s1=Part.find_by_id(pe.value_s1)
      raise 's1 error' if pe.value_s1_qty_factor.blank?
      puts "s1: #{s1.nr}---#{pe.value_s1_qty_factor}"
      PartBom.create(part_id: part.id, bom_item_id: s1.id, quantity: pe.value_s1_qty_factor)
    end

    if s2=Part.find_by_id(pe.value_s2)
      raise 's2 error' if pe.value_s2_qty_factor.blank?
      puts "s2: #{s2.nr}---#{pe.value_s2_qty_factor}".blue
      if pb=PartBom.where(part_id: part.id, bom_item_id: s2.id).first
        puts "-----------s1 & s2".yellow
        pb.update(quantity: (pb.quantity+pe.value_s2_qty_factor.to_f))
      else
        PartBom.create(part_id: part.id, bom_item_id: s2.id, quantity: pe.value_s2_qty_factor)
      end
    end

  end
end