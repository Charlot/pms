Kanban.all.each do |k|
  unless k.kanban_part
    puts "#{k.to_josn}".yellow
    k.create_part_bom
  end
end