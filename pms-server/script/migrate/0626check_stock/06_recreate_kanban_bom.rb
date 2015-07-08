Kanban.all.each do |k|
  unless k.kanban_part
    k.create_part_bom
  end
end