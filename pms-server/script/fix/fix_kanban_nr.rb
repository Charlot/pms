Kanban.transaction do
  Kanban.all.each do |kanban|
    kanban.update_attributes({nr: (kanban.nr.to_i + 100000).to_s})
  end
end