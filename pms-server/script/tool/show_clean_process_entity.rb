ProcessEntity.all.each do |pe|
  if pe.kanban_process_entities.count == 0
    puts "#{pe.nr}:#{pe.product_nr}".blue
  end
end