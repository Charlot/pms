ProcessEntity.all.each do |pe|
  if part_id = pe.value_default_wire_nr
    part = Part.find_by_id(part_id)
    pe.process_parts << ProcessPart.create({part_id:part.id}) unless pe.process_parts.collect{|pp|pp.id}.include? part.id
    pe.save
    puts "#{part.nr}创建"
  end
end