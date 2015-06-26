Kanban.transaction do
  Kanban.where("des_storage like ' % '").each do |k|
    puts k.nr.red
    puts k.des_storage.blue
    k.update_attributes(des_storage: k.des_storage.strip)
    puts k.des_storage.green
    position_nr=Warehouse::DEFAULT_POSITION
    whouse_nr=Warehouse::DEFAULT_WAREHOUSE
    begin
      position_nr=k.des_storage
      whouse_nr=Warehouse.get_whouse_by_position_prefix(k.des_storage)
    end

    k.production_order_item_labels.each do |l|
      puts "#{l.nr}".yellow
      l.update_attributes(position_nr: position_nr, whouse_nr: whouse_nr)
    end
  end
end
ProductionOrderItemLabel.transaction do
  ProductionOrderItemLabel.where("position_nr like ' % '").each_with_indx do |l,i|
    puts "#{i}---#{l.nr}".red

    position_nr=Warehouse::DEFAULT_POSITION
    whouse_nr=Warehouse::DEFAULT_WAREHOUSE
    begin
      position_nr=l.position_nr.strip
      whouse_nr=Warehouse.get_whouse_by_position_prefix(position_nr)
    end

    l.update_attributes(position_nr: position_nr, whouse_nr: whouse_nr)
  end
end