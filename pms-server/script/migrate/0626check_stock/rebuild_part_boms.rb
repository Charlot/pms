
Kanban.all.each_with_index do |k,i|

  # if ['006034','006035','006036'].include?(k.nr)
  #   k.update_attributes(ktype:KanbanType::BLUE)
  # end

  puts "----------------------#{i}----#{k.id}--#{k.nr}---------------------------".green
  k.create_part_bom
end