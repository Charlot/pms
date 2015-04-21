Kanban.where(ktype:KanbanType::WHITE).each do |k|
  if k.quantity>0 &&k.quantity < 200
    if k.bundle <=0
      #k.update(bundle:k.quantity)
      #puts "<0".green
      puts "=================="
    else
      if (k.quantity % k.bundle )> 0
        puts ">0".red
        k.update(bundle:k.quantity)
      else
        #puts "#{k.quantity % k.bundle}"
      end
    end
  end
end