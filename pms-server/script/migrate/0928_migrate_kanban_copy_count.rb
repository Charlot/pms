# Kanban.group(:des_storage).select('count(*) as des_count,des_storage').each_with_index do |k, i|
#   puts "#{i+1}...#{k.des_count}..#{k.des_storage}..."
#   unless k.des_storage.blank?
#     Kanban.where(des_storage: k.des_storage).update_all(auto_copy_count: k.des_count)
#   end
# end

# check no kanban process entity
# KanbanProcessEntity.pluck(:kanban_id).uniq.each { |kanban_id| puts(kanban_id) unless Kanban.unscoped.find_by_id(kanban_id) }
Kanban.benchmark('kanban auto copy count migrate') do
  Kanban.joins(:kanban_process_entities)
      .where(kanban_process_entities: {position: 0}).where.not(kanbans:{state:KanbanState::DELETED})
      .group(:product_id, :process_entity_id)
      .select('count(*) as size,product_id,kanban_process_entities.process_entity_id').each_with_index do |item, i|
    puts "#{i+1}...#{item[:product_id]}----#{item[:process_entity_id]}--------#{item[:size]}"
    Kanban.joins(:kanban_process_entities).where(product_id: item.product_id,
                                                 kanban_process_entities: {position: 0, process_entity_id: item[:process_entity_id]})
        .update_all(auto_copy_count: item.size)
  end
end