class ItemBlueMoveStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)
    if (item=ProductionOrderItemBlue.find_by_id(id)) && (kb =item.kanban)
      toWh=toPosition=Warehouse.get_whouse_by_position_prefix(kb.des_storage)
      base_params={toWh: toWh,
                   toPosition: toPosition}
      moved_parts=[]
      moves=[]
      kb.kanban_process_entities.each do |kpe|
        pe=kpe.process_entity

        pe.process_parts.each do |pp|
          if part=Part.find_by_id(pp.part_id)
            if PartType.is_material?(part.type)
              qty=part.type==PartType::MATERIAL_WIRE ? pp.quantity/1000 : pp.quantity
              moves<<base_params.merge({
                                           fromWh: 'SR01',
                                           fromPosition: 'SR01',
                                           qty: qty,
                                           partNr: part.nr
                                       })
            elsif part.type==PartType::PRODUCT_SEMIFINISHED and !moved_parts.include?(part.id) and part.id!=pe.value_default_wire_nr.to_i
              # 如果按步骤销料，需要根据目前步骤的position来找到之前的所有步骤，判断半成品是否被销过
              # 这个需要重新查询数据库，目前的是批量销卡可以使用变量来跟踪
              moved_parts<<part.id
              part.part_boms.joins(:bom_item).select('part_boms.*,parts.nr,parts.type as part_type').each do |pb|
                qty = (pb.part_type==PartType::MATERIAL_WIRE ? pb.quantity/1000 : pb.quantity)*pp.quantity
                moves<<base_params.merge({fromWh: 'SRPL',
                                          fromPosition: 'SRPL',
                                          qty: qty,
                                          partNr: pb.nr
                                         })
              end
            end
          end
        end
      end
      Whouse::Storage.new.move_stocks(moves) if moves.size>0
    end
  end
end