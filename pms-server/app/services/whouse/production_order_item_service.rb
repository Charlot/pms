class ProductionOrderItemService
  def self.move_stock(id, from_whouse='SR01', from_position='SR01')
    ProductionOrderItem.transaction do
      if (item=ProductionOrderItem.find_by_id(id))
        if kb=item.kanban


          whouse_nr=Warehouse.get_whouse_by_position_prefix(kb.des_storage)

          base_params={
              toWh: whouse_nr,
              toPosition: whouse_nr,
              fromWh: from_whouse
          }
          moves=[]
          puts "white kanban#{kb.to_json}".red

          kb.create_part_bom(false)

          kb.materials.each do |material|
            puts "white: #{material.to_json}".red
            moves<<base_params.merge({
                                         remarks: "看板:#{kb.nr},订单#{item.nr}",
                                         qty: BigDecimal.new(material.quantity.to_s)*item.produced_qty,
                                         partNr: material.nr
                                     })
          end

          puts "white kanban#{moves.to_json}".yellow

          Whouse::StorageClient.new.move_stocks(moves) if moves.size>0
        end
      end
    end
  end

  def self.move_blue_stock(id, from_whouse='SRPL', from_position='SRPL')
    ProductionOrderItemBlue.transaction do
      if (item=ProductionOrderItemBlue.find_by_id(id))
        if kb=item.kanban
          whouse_nr=Warehouse.get_whouse_by_position_prefix(kb.des_storage)

          base_params={
              toWh: whouse_nr,
              toPosition: whouse_nr,
              fromWh: from_whouse
          }
          moves=[]
          puts "blue kanban#{kb.to_json}".red

          kb.create_part_bom(false)

          # kb.kanban_part.materials_with_deep.each do |material|
          #   puts "blue: #{material.to_json}".yellow
          #   moves<<base_params.merge({
          #                                remarks:kb.nr,
          #                                qty: BigDecimal.new(material.quantity.to_s)*label.qty,
          #                                partNr: material.part_nr,
          #                                from_whouse: material.deep==1 ? 'SR01' : 'SRPL'
          #                            })
          # end


          kb.kanban_part.materials.each do |material|
            puts "blue: #{material.to_json}".yellow
            moves<<base_params.merge({
                                         remarks: "看板:#{kb.nr},订单#{item.nr}",
                                         qty: BigDecimal.new(material.quantity.to_s)*item.produced_qty,
                                         partNr: material.nr
                                     })
          end

          puts "blue kanban#{moves.to_json}".yellow

          Whouse::StorageClient.new.move_stocks(moves) if moves.size>0
        end
      end
    end
  end
end
