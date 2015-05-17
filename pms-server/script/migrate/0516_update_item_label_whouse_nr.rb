ProductionOrderItemLabel.all.each_with_index do |label, i|
  # if label.whouse_nr.blank?
    time=label.updated_at
    puts "#{i}------#{label.id}------#{label.position_nr}"
    label.update(whouse_nr: Warehouse.get_whouse_by_position_prefix(label.position_nr), updated_at: time)
  # end
end