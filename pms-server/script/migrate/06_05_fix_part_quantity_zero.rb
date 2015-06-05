ProcessPart.transaction do
  ProcessEntity.joins(:process_template)
      .where(process_templates: {type: ProcessType::SEMI_AUTO}).all.each do |pe|
    puts "#{pe.nr}".blue
    pe.process_parts.where(quantity: 0).each do |pp|
      puts "#{Part.find(pp.part_id).nr}".red
      pp.update(quantity: 1)
    end
  end
end