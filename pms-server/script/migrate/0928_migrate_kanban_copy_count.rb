# Kanban.group(:des_storage).select('count(*) as des_count,des_storage').each_with_index do |k, i|
#   puts "#{i+1}...#{k.des_count}..#{k.des_storage}..."
#   unless k.des_storage.blank?
#     Kanban.where(des_storage: k.des_storage).update_all(auto_copy_count: k.des_count)
#   end
# end

# check no kanban process entity
# KanbanProcessEntity.pluck(:kanban_id).uniq.each { |kanban_id| puts(kanban_id) unless Kanban.unscoped.find_by_id(kanban_id) }

KanbanProcessEntity.where(position: 0).each_with_index do |process, i|
  puts "#{i+1}....#{process.kanban_id}"
  if kanban=process.kanban
    puts "#{kanban.nr}.....".yellow

  end
end