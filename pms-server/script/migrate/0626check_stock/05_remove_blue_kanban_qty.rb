# select created_at,qty,kanban_nr from production_order_handler_items where qty=2015 and result=100 order by kanban_nr;
ProductionOrderItemBlueLabel.transaction do

  ProductionOrderItemBlueLabel.where(qty: 2015, state: ProductionOrderItemLabel::IN_STORE).all.each do |item|
    puts "#{item.to_json}".blue
    if kb =item.production_order_item_blue.kanban

      moves=[]

      kb.kanban_part.materials_with_deep.each do |material|
        puts "blue: #{material.to_json}".yellow
        moves<<{fromWh: Warehouse.get_whouse_by_position_prefix(kb.des_storage),
                remarks: '看板模版变更，数量错误2015:'+kb.nr,
                qty: BigDecimal.new(material.quantity.to_s)*(2015-kb.quantity),
                partNr: material.part_nr,
                toWh: material.deep==1 ? 'SR01' : 'SRPL',
                toPosition: material.deep==1 ? 'SR01' : 'SRPL'
        }
      end
      puts "blue kanban#{moves.to_json}".yellow
      item.update(qty: kb.quantity)
      Whouse::Storage.new.move_stocks(moves) if moves.size>0
    end
  end
  ProductionOrderItemBlueLabel.where(qty: 2015).each do |item|
    if kb =item.production_order_item_blue.kanban
      item.update(qty: kb.quantity)
    end
  end
end