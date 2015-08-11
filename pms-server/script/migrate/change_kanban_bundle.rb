Kanban.where(ktype:KanbanType::WHITE).each{|kanban|
  kanban.without_versioning do
    #kanban.update(bundle:kanban.quantity)
    unless kanban.bundle != 0 && (kanban.quantity % kanban.bundle == 0)
      kanban.update(bundle:kanban.quantity)
    end
    puts "#{kanban.nr},#{kanban.product_nr},#{kanban.wire_nr}:#{kanban.quantity}:#{kanban.bundle}"
  end
}