Tool.all.each do |t|
  if t.part_id
    pt= PartTool.new(tool_id: t.id, part_id: t.part_id)
    if pt.save
      puts "** #{t.nr} & #{Part.find(t.part_id).nr} **".yellow
    else
      puts "!! #{pt.errors.messages.to_json} !!".blue
    end
  else
    puts "..#{t.nr} has no part..".red
  end
end