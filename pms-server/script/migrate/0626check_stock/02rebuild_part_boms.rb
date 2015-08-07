PartBom.delete_all
Kanban.all.each_with_index do |k, i|
  puts "----------------------#{i}----#{k.id}--#{k.nr}---------------------------".green
  k.create_part_bom
end